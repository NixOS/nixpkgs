{ lib
, buildPythonPackage
, fetchFromGitHub
, filelock
, flit-core
, importlib-metadata
, isPy3k
, packaging
, pep517
, pytest-mock
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, pythonOlder
, toml
, typing ? null
}:

buildPythonPackage rec {
  pname = "build";
  version = "0.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    sha256 = "15hc9mbxsngfc9n805x8rk7yqbxnw12mpk6hfwcsldnfii1vg2ph";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    toml
    pep517
    packaging
  ] ++ lib.optionals (!isPy3k) [
    typing
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    filelock
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    "test_isolation"
    "test_isolated_environment_install"
    "test_default_pip_is_never_too_old"
    "test_build"
    "test_init"
  ];

  pythonImportsCheck = [ "build" ];

  meta = with lib; {
    description = "Simple, correct PEP517 package builder";
    longDescription = ''
      build will invoke the PEP 517 hooks to build a distribution package. It
      is a simple build tool and does not perform any dependency management.
    '';
    homepage = "https://github.com/pypa/build";
    maintainers = with maintainers; [ fab ];
    license = licenses.mit;
  };
}
