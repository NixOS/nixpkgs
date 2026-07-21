{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-magic,
  requests,
}:

buildPythonPackage rec {
  pname = "pycketcasts";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nwithan8";
    repo = "pycketcasts";
    rev = version;
    hash = "sha256-O4j89fE7fYPthhCH8b2gGskkelEA4mU6GvSbKIl+4Mk=";
  };

  propagatedBuildInputs = [
    python-magic
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pycketcasts" ];

  meta = {
    description = "Module to interact with PocketCast's unofficial API";
    homepage = "https://github.com/nwithan8/pycketcasts";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
