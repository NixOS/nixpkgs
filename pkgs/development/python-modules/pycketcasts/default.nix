{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-magic,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pycketcasts";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Module to interact with PocketCast's unofficial API";
    homepage = "https://github.com/nwithan8/pycketcasts";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
