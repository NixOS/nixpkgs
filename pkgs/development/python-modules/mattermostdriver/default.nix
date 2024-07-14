{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  websockets,
  requests,
}:

buildPythonPackage rec {
  pname = "mattermostdriver";
  version = "7.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

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

  meta = with lib; {
    description = "Python Mattermost Driver";
    homepage = "https://github.com/Vaelor/python-mattermost-driver";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
