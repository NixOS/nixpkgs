{
  lib,
  buildPythonPackage,
  fetchPypi,
  websockets,
  requests,
}:

buildPythonPackage rec {
  pname = "mattermostdriver";
  version = "7.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lk17ShfTAT4nnG+ZN0bqGM1gtF2Po74k9HvC3iK5s7Q=";
  };

  propagatedBuildInputs = [
    websockets
    requests
  ];

  pythonImportsCheck = [ "mattermostdriver" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Python Mattermost Driver";
    homepage = "https://github.com/Vaelor/python-mattermost-driver";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
