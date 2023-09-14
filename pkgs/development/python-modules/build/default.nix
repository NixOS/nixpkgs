{ lib
, stdenv
, build
, buildPythonPackage
, fetchFromGitHub
, flit-core
, filelock
, packaging
, pyproject-hooks
, pytest-mock
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
, setuptools
, toml
, tomli
}:

buildPythonPackage rec {
  pname = "build";
  version = "1.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "build";
    rev = "refs/tags/${version}";
    hash = "sha256-SGWpm+AGIfqKMpDfmz2aMYmcs+XVREbHIXSuU4R7U/k=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    packaging
    pyproject-hooks
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  # We need to disable tests because this package is part of the bootstrap chain
  # and its test dependencies cannot be built yet when this is being built.
  doCheck = false;

  passthru.tests = {
    pytest = buildPythonPackage {
      pname = "${pname}-pytest";
      inherit version;
      format = "other";

      dontBuild = true;
      dontInstall = true;

      nativeCheckInputs = [
        build
        filelock
        pytest-mock
        pytest-rerunfailures
        pytest-xdist
        pytestCheckHook
        setuptools
        toml
      ];

      pytestFlagsArray = [
        "-W"
        "ignore::DeprecationWarning"
      ];

      __darwinAllowLocalNetworking = true;

      disabledTests = [
        # Tests often fail with StopIteration
        "test_isolat"
        "test_default_pip_is_never_too_old"
        "test_build"
        "test_with_get_requires"
        "test_init"
        "test_output"
        "test_wheel_metadata"
      ] ++ lib.optionals stdenv.isDarwin [
        # Expects Apple's Python and its quirks
        "test_can_get_venv_paths_with_conflicting_default_scheme"
      ];
    };
  };

  pythonImportsCheck = [
    "build"
  ];

  meta = with lib; {
    mainProgram = "pyproject-build";
    description = "Simple, correct PEP517 package builder";
    longDescription = ''
      build will invoke the PEP 517 hooks to build a distribution package. It
      is a simple build tool and does not perform any dependency management.
    '';
    homepage = "https://github.com/pypa/build";
    changelog = "https://github.com/pypa/build/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = teams.python.members ++ [ maintainers.fab ];
  };
}
