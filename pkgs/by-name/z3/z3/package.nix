{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  fixDarwinDylibNames,
  nix-update-script,
  versionCheckHook,

  javaBindings ? false,
  ocamlBindings ? false,
  pythonBindings ? (!stdenv.hostPlatform.isStatic),
  jdk ? null,
  ocaml ? null,
  findlib ? null,
  zarith ? null,
  cmake,
  ninja,
  testers,
  useCmakeBuild ? true, # fstar needs the legacy build system for older z3 versions
}:

assert pythonBindings -> !stdenv.hostPlatform.isStatic;
assert javaBindings -> jdk != null && (!stdenv.hostPlatform.isStatic);
assert
  ocamlBindings
  -> ocaml != null && findlib != null && zarith != null && (!stdenv.hostPlatform.isStatic);

stdenv.mkDerivation (finalAttrs: {
  pname = "z3";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = "z3";
    rev = "z3-${finalAttrs.version}";
    hash = "sha256-WjVLuYMWHrwFQMTwLxt8r+QaSSPi33LTuxL/sCKKzPU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    python3Packages.python
  ]
  ++ lib.optionals pythonBindings [ python3Packages.setuptools ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ]
  ++ lib.optionals javaBindings [ jdk ]
  ++ lib.optionals ocamlBindings [
    ocaml
    findlib
  ]
  ++ lib.optionals useCmakeBuild [
    cmake
    ninja
  ];

  propagatedBuildInputs = lib.optionals ocamlBindings [ zarith ];
  enableParallelBuilding = true;

  postPatch =
    lib.optionalString ocamlBindings ''
      export OCAMLFIND_DESTDIR=$ocaml/lib/ocaml/${ocaml.version}/site-lib
      mkdir -p $OCAMLFIND_DESTDIR/stublibs
    ''
    + lib.optionalString useCmakeBuild ''
      # Fix the pkg-config paths.
      substituteInPlace z3.pc.cmake.in \
        --replace-fail "prefix=\''${pcfiledir}/" "prefix=" \
        --replace-fail "libdir=\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" "libdir=@CMAKE_INSTALL_FULL_LIBDIR@" \
        --replace-fail "includedir=\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@"
    '';

  configurePhase = lib.optionalString (!useCmakeBuild) ''
    runHook preConfigure

    ${python3Packages.python.pythonOnBuildForHost.interpreter} \
      scripts/mk_make.py \
      --prefix=$out \
      ${lib.optionalString javaBindings "--java"} \
      ${lib.optionalString ocamlBindings "--ml"} \
      ${lib.optionalString pythonBindings "--python --pypkgdir=$out/${python3Packages.python.sitePackages}"}

    cd build

    runHook postConfigure
  '';

  cmakeFlags = [
    (lib.cmakeBool "Z3_BUILD_PYTHON_BINDINGS" pythonBindings)
    (lib.cmakeBool "Z3_INSTALL_PYTHON_BINDINGS" pythonBindings)
    (lib.cmakeBool "Z3_BUILD_JAVA_BINDINGS" javaBindings)
    (lib.cmakeBool "Z3_INSTALL_JAVA_BINDINGS" javaBindings)
    (lib.cmakeBool "Z3_BUILD_OCAML_BINDINGS" ocamlBindings)
    (lib.cmakeBool "Z3_SINGLE_THREADED" (!finalAttrs.enableParallelBuilding))
    (lib.cmakeBool "Z3_BUILD_LIBZ3_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "out"))
    (lib.cmakeBool "Z3_BUILD_TEST_EXECUTABLES" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "Z3_ENABLE_EXAMPLE_TARGETS" false)
  ]
  ++ lib.optionals pythonBindings [
    (lib.cmakeFeature "CMAKE_INSTALL_PYTHON_PKG_DIR" "${placeholder "python"}/${python3Packages.python.sitePackages}")
    (lib.cmakeFeature "Python3_EXECUTABLE" python3Packages.python.pythonOnBuildForHost.interpreter)
  ]
  ++ lib.optionals javaBindings [
    (lib.cmakeFeature "Z3_JAVA_JNI_LIB_INSTALLDIR" "${placeholder "java"}/lib")
    (lib.cmakeFeature "Z3_JAVA_JAR_INSTALLDIR" "${placeholder "java"}/share/java")
  ]
  ++ lib.optionals ocamlBindings [
    (lib.cmakeFeature "Z3_OCAML_PACKAGE_INSTALLDIR" "${placeholder "ocaml"}/lib/ocaml/${ocaml.version}/site-lib/Z3")
    (lib.cmakeFeature "Z3_OCAML_STUB_INSTALLDIR" "${placeholder "ocaml"}/lib/ocaml/${ocaml.version}/site-lib/stublibs")
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ${if useCmakeBuild then "ninja test-z3" else "make test"} -j $NIX_BUILD_CORES
    ./test-z3 -a

    runHook postCheck
  '';

  postInstall =
    lib.optionalString (!useCmakeBuild) (
      ''
        mkdir -p $dev $lib
        mv $out/lib $lib/lib
        mv $out/include $dev/include
      ''
      + lib.optionalString pythonBindings ''
        mkdir -p $python/lib
        mv $lib/lib/python* $python/lib/

        # need to delete the lib folder to properly link the actual lib output
        rm -rf $python/${python3Packages.python.sitePackages}/z3/lib
      ''
      + lib.optionalString javaBindings ''
        mkdir -p $java/share/java $java/lib
        mv $lib/lib/com.microsoft.z3.jar $java/share/java
        mv $lib/lib/libz3java* $java/lib
      ''
    )
    + lib.optionalString pythonBindings ''
      # delete dangling symlink
      rm -f $python/${python3Packages.python.sitePackages}/z3/libz3.so.*
      ln -sf $lib/lib $python/${python3Packages.python.sitePackages}/z3/lib
    '';

  # remove /build from RPATH
  preFixup = lib.optionalString (useCmakeBuild && ocamlBindings && stdenv.hostPlatform.isElf) ''
    for f in $OCAMLFIND_DESTDIR/stublibs/dllz3ml.so $OCAMLFIND_DESTDIR/Z3/z3ml.cmxs; do
      rpath="$(patchelf --print-rpath "$f" | tr ':' '\n' | { grep -v "^$NIX_BUILD_TOP/" || true; } | paste -sd:)"
      patchelf --set-rpath "$lib/lib''${rpath:+:$rpath}" "$f"
    done
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ]
  ++ lib.optionals pythonBindings [ python3Packages.pythonImportsCheckHook ];

  pythonImportsCheck = [
    "z3"
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ]
  ++ lib.optionals pythonBindings [ "python" ]
  ++ lib.optionals javaBindings [ "java" ]
  ++ lib.optionals ocamlBindings [ "ocaml" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^z3-([0-9]+\\.[0-9]+\\.[0-9]+)$"
      ];
    };
    tests = lib.optionalAttrs useCmakeBuild {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "z3";
    homepage = "https://github.com/Z3Prover/z3";
    changelog = "https://github.com/Z3Prover/z3/releases/tag/z3-${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      numinit
    ];
    pkgConfigModules = lib.optionals useCmakeBuild [ "z3" ];
  };
})
