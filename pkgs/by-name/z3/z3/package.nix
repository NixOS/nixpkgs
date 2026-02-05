{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
  useCmakeBuild ? (!ocamlBindings), # TODO: remove gnu make build once cmake supports ocaml
}:

assert pythonBindings -> !stdenv.hostPlatform.isStatic;
assert javaBindings -> jdk != null && (!stdenv.hostPlatform.isStatic);
assert
  ocamlBindings
  -> ocaml != null && findlib != null && zarith != null && (!stdenv.hostPlatform.isStatic);

stdenv.mkDerivation (finalAttrs: {
  pname = "z3";
  version = "4.15.4";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = "z3";
    rev = "z3-${finalAttrs.version}";
    hash = "sha256-eyF3ELv81xEgh9Km0Ehwos87e4VJ82cfsp53RCAtuTo=";
  };

  patches =
    lib.optionals useCmakeBuild [
      ./fix-pkg-config-paths.patch
    ]
    ++ lib.optionals (lib.versionAtLeast finalAttrs.version "4.15.4") [
      # fix Segmentation fault. See https://github.com/Z3Prover/z3/pull/8264 and
      # https://github.com/NixOS/nixpkgs/issues/486491
      (fetchpatch2 {
        name = "preserve-the-initial-state-of-the-solver.patch";
        url = "https://github.com/Z3Prover/z3/commit/850a3236adab92f9f6f569ac66ffbb69be179f4c.patch?full_index=1";
        hash = "sha256-C6p+dj3i3DpOnd2wr+R8ZwClHoMFfk5i5/+JRhTDNcs=";
      })
      # needs to include a cosmetic change to apply patch for memory corruption
      (fetchpatch2 {
        name = "cosmetic-changes-to-i.patch";
        url = "https://github.com/Z3Prover/z3/commit/243694379475d983605f87578452a330f3e3b28f.patch?full_index=1";
        includes = [ "src/api/api_polynomial.cpp" ];
        hash = "sha256-huo5S73WrFrEEUcaP+1LDQwGwo+n2iYT4x/OjK5rmqQ=";
      })
      (fetchpatch2 {
        name = "fix-memory-corruption.patch";
        url = "https://github.com/Z3Prover/z3/commit/e7b6f3f33bcc6c88a0f2ace47ff2f09b59239433.patch?full_index=1";
        hash = "sha256-kEEeod4s8i9SI2e2TFD2U4yd1qEPoGnJOfE0y+1Cq6M=";
      })
    ];

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

  postPatch = lib.optionalString ocamlBindings ''
    export OCAMLFIND_DESTDIR=$ocaml/lib/ocaml/${ocaml.version}/site-lib
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
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
    (lib.cmakeBool "Z3_BUILD_OCAML_BINDINGS" ocamlBindings) # FIXME: ocaml does not properly install build output on cmake
    (lib.cmakeBool "Z3_SINGLE_THREADED" (!finalAttrs.enableParallelBuilding))
    (lib.cmakeBool "Z3_BUILD_LIBZ3_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "out"))
    (lib.cmakeBool "Z3_BUILD_TEST_EXECUTABLES" finalAttrs.doCheck)
    (lib.cmakeBool "Z3_ENABLE_EXAMPLE_TARGETS" false)
  ]
  ++ lib.optionals pythonBindings [
    (lib.cmakeFeature "CMAKE_INSTALL_PYTHON_PKG_DIR" "${placeholder "python"}/${python3Packages.python.sitePackages}")
    (lib.cmakeFeature "Python3_EXECUTABLE" "${lib.getExe python3Packages.python}")
  ]
  ++ lib.optionals javaBindings [
    (lib.cmakeFeature "Z3_JAVA_JNI_LIB_INSTALLDIR" "${placeholder "java"}/lib")
    (lib.cmakeFeature "Z3_JAVA_JAR_INSTALLDIR" "${placeholder "java"}/share/java")
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
      ln -sf $lib/lib $python/${python3Packages.python.sitePackages}/z3/lib
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
      ttuegel
      numinit
    ];
    pkgConfigModules = lib.optionals useCmakeBuild [ "z3" ];
    broken = useCmakeBuild && ocamlBindings;
  };
})
