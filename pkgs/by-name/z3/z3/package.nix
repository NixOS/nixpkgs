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
  patchelf,
  testers,
}:

assert pythonBindings -> !stdenv.hostPlatform.isStatic;
assert javaBindings -> jdk != null && (!stdenv.hostPlatform.isStatic);
assert
  ocamlBindings
  -> ocaml != null && findlib != null && zarith != null && (!stdenv.hostPlatform.isStatic);

stdenv.mkDerivation (finalAttrs: {
  pname = "z3";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = "z3";
    rev = "z3-${finalAttrs.version}";
    hash = "sha256-vKNrsm09LGu8pgkX5Yv0XlY3u/MAawoma3BIeavS8So=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    python3Packages.python
    cmake
    ninja
  ]
  ++ lib.optionals pythonBindings [ python3Packages.setuptools ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ]
  ++ lib.optionals javaBindings [ jdk ]
  ++ lib.optionals ocamlBindings [
    ocaml
    findlib
  ]
  ++ lib.optionals (ocamlBindings && stdenv.hostPlatform.isElf) [
    patchelf
  ];

  propagatedBuildInputs = lib.optionals ocamlBindings [ zarith ];
  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace z3.pc.cmake.in \
      --replace-fail "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"
  ''
  + lib.optionalString ocamlBindings ''
    export OCAMLFIND_DESTDIR=$ocaml/lib/ocaml/${ocaml.version}/site-lib
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
  ''
  + lib.optionalString (ocamlBindings && stdenv.hostPlatform.isDarwin) ''
    # Upstream assumes the OCaml stub directory is relative.
    substituteInPlace src/api/ml/CMakeLists.txt \
      --replace-fail "\\\''${CMAKE_INSTALL_PREFIX}/" ""
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

    ninja test-z3 -j $NIX_BUILD_CORES
    ./test-z3 -a

    runHook postCheck
  '';

  postInstall =
    lib.optionalString (ocamlBindings && stdenv.hostPlatform.isElf) ''
      # CMake leaves the temporary build directory in these libraries' RPATHs.
      for file in "$OCAMLFIND_DESTDIR"/{Z3/z3ml.cmxs,stublibs/dllz3ml.so}; do
        patchelf --add-rpath "$lib/lib" "$file"
        patchelf --shrink-rpath --allowed-rpath-prefixes "${builtins.storeDir}" "$file"
      done
    ''
    + lib.optionalString pythonBindings ''
      # delete dangling symlink
      rm -f $python/${python3Packages.python.sitePackages}/z3/libz3.so.*
      ln -sf $lib/lib $python/${python3Packages.python.sitePackages}/z3/lib

      # Generate upstream's Python distribution metadata without rebuilding Z3.
      pushd ../src/api/python
      ${python3Packages.python.pythonOnBuildForHost.interpreter} setup.py egg_info \
        --egg-base "$python/${python3Packages.python.sitePackages}"
      popd
    '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ]
  ++ lib.optionals pythonBindings [ python3Packages.pythonImportsCheckHook ];

  pythonImportsCheck = [
    "z3"
  ];

  postInstallCheck = lib.optionalString pythonBindings ''
    PYTHONPATH="$python/${python3Packages.python.sitePackages}:$PYTHONPATH" \
      ${python3Packages.python.pythonOnBuildForHost.interpreter} - <<'PY'
    import importlib.metadata
    import z3

    assert importlib.metadata.version("z3-solver") == ".".join(map(str, z3.get_version()))
    PY
  '';

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
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
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
    pkgConfigModules = [ "z3" ];
  };
})
