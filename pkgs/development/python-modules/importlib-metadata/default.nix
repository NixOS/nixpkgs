{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
, typing-extensions
, zipp
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "6.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python";
    repo = "importlib_metadata";
    rev = "refs/tags/v${version}";
    hash = "sha256-73AkriM1QgXKOlrCxrC/AG+IEXjo+kPjQrxfVFHIJlc=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    zipp
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # Cyclic dependencies due to pyflakefs
  doCheck = false;

  pythonImportsCheck = [
    "importlib_metadata"
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
