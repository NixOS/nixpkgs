{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, websockets
, requests
}:

buildPythonPackage rec {
  pname = "mattermostdriver";
  version = "7.3.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e4d7b4a17d3013e279c6f993746ea18cd60b45d8fa3be24f47bc2de22b9b3b4";
  };

  propagatedBuildInputs = [ websockets requests ];

  pythonImportsCheck = [ "mattermostdriver" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A Python Mattermost Driver";
    homepage = "https://github.com/Vaelor/python-mattermost-driver";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
