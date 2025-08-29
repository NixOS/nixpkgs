{
  stdenv,
  lib,
  makeSetupHook,
  python,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  scikit-build-core,

  # cmakeFlags
  boost,
  eigen,

  # tests
  catch2,
  numpy,
  pytestCheckHook,

  pytest,
  pybind11_3,
}:
let
  setupHook = makeSetupHook {
    name = "pybind11-setup-hook";
    substitutions = {
      out = placeholder "out";
      pythonInterpreter = python.pythonOnBuildForHost.interpreter;
      pythonIncludeDir = "${python}/include/python${python.pythonVersion}";
      pythonSitePackages = "${python}/${python.sitePackages}";
    };
  } ./setup-hook.sh;
in
buildPythonPackage rec {
  pname = "pybind11";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    tag = "v${version}";
    hash = "sha256-ZiwNGsE1FOkhnWv/1ib1akhQ4FZvrXRCDnnBZoPp6r4=";
  };

  build-system = [
    cmake
    ninja
    scikit-build-core
  ];

  buildInputs = [
    boost

    # Used only for building tests, something we do even when cross compiling
    catch2

    eigen
  ];

  propagatedNativeBuildInputs = [ setupHook ];

  dontUseCmakeBuildDir = true;

  env = {
    SKBUILD_CMAKE_ARGS = lib.strings.concatStringsSep ";" [
      # Always build tests, because even when cross compiling building the tests
      # is another confirmation that everything is OK.
      (lib.cmakeBool "BUILD_TESTING" true)

      # From some reason this is needed for tests
      (lib.cmakeBool "PYBIND11_NOPYTHON" false)
    ];
  };

  postBuild = ''
    # build tests
    make -j $NIX_BUILD_CORES
  '';

  postInstall = ''
    make install
    # Symlink the CMake-installed headers to the location expected by setuptools
    mkdir -p $out/include/${python.libPrefix}
    ln -sf $out/include/pybind11 $out/include/${python.libPrefix}/pybind11
  '';

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # require dependencies not available in nixpkgs
    "tests/test_embed/test_trampoline.py"
    "tests/test_embed/test_interpreter.py"
    # numpy changed __repr__ output of numpy dtypes
    "tests/test_numpy_dtypes.py"
    # no need to test internal packaging
    "tests/extra_python_package/test_files.py"
    # tests that try to parse setuptools stdout
    "tests/extra_setuptools/test_setuphelper.py"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # expects KeyError, gets RuntimeError
    # https://github.com/pybind/pybind11/issues/4243
    "test_cross_module_exception_translator"
  ];

  doCheck = false;

  hardeningDisable = lib.optional stdenv.hostPlatform.isMusl "fortify";

  passthru = {
    tests.pytest = buildPythonPackage {
      pname = "pybind11_tests";
      inherit version src;
      pyproject = true;

      sourceRoot = "${src.name}/tests";

      buildInputs = [
        pybind11_3
      ]
      ++ buildInputs;

      inherit build-system dontUseCmakeBuildDir;

      dependencies = [ pytest ];
    };
  };

  meta = {
    homepage = "https://github.com/pybind/pybind11";
    changelog = "https://github.com/pybind/pybind11/blob/${src.rev}/docs/changelog.rst";
    description = "Seamless operability between C++11 and Python";
    mainProgram = "pybind11-config";
    longDescription = ''
      Pybind11 is a lightweight header-only library that exposes
      C++ types in Python and vice versa, mainly to create Python
      bindings of existing C++ code.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      yuriaisaka
      dotlambda
    ];
  };
}
