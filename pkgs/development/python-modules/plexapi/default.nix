{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, tqdm
, websocket-client
, pythonOlder
}:

buildPythonPackage rec {
  pname = "plexapi";
  version = "4.7.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    rev = version;
    sha256 = "1gh36ln9ki69rs7ml9syqq956i996rdi145qffjwb3736zylrzkp";
  };

  propagatedBuildInputs = [
    requests
    tqdm
    websocket-client
  ];

  # Tests require a running Plex instance
  doCheck = false;

  pythonImportsCheck = [ "plexapi" ];

  meta = with lib; {
    description = "Python bindings for the Plex API";
    homepage = "https://github.com/pkkid/python-plexapi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
  };
}
