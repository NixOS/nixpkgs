{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, numpy
, pydantic
, pytest-mypy-plugins
, pytestCheckHook
, pythonOlder
, setuptools-scm
, typing-extensions
, wheel
, wrapt
}:

buildPythonPackage rec {
  pname = "psygnal";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tlambert03";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Hh1HG4VVcNXo62M/4mU3ZcSQNHmalcIDprkwD6/WRf8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    numpy
    pydantic
    pytest-mypy-plugins
    pytestCheckHook
    wrapt
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=psygnal --cov-report=term-missing" ""
  '';

  pythonImportsCheck = [
    "psygnal"
  ];

  meta = with lib; {
    description = "Implementation of Qt Signals";
    homepage = "https://github.com/tlambert03/psygnal";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
