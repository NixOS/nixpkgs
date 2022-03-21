{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, filelock
, flit-core
, importlib-metadata
, packaging
, pep517
, pytest-mock
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
, toml
, tomli
}:

buildPythonPackage rec {
  pname = "build";
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    sha256 = "sha256-kT3Gax/ZCeV8Kb7CBArGWn/qzVSVdMRUoid/8cAovnE=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    packaging
    pep517
    tomli
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    filelock
    toml
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-n"
    "$NIX_BUILD_CORES"
    "-W"
    "ignore::DeprecationWarning"
  ];

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

  pythonImportsCheck = [
    "build"
  ];

  meta = with lib; {
    description = "Simple, correct PEP517 package builder";
    longDescription = ''
      build will invoke the PEP 517 hooks to build a distribution package. It
      is a simple build tool and does not perform any dependency management.
    '';
    homepage = "https://github.com/pypa/build";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
