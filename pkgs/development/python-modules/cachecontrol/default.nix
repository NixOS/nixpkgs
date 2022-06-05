{ lib
, buildPythonPackage
, cherrypy
, fetchFromGitHub
, lockfile
, mock
, msgpack
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "cachecontrol";
  version = "0.12.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mgvL0q10UbPHY1H3tJprke5p8qNl3HNYoeLAERZTcTs=";
  };

  propagatedBuildInputs = [
    lockfile
    msgpack
    requests
  ];

  checkInputs = [
    cherrypy
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cachecontrol"
  ];

  meta = with lib; {
    description = "Httplib2 caching for requests";
    homepage = "https://github.com/ionrock/cachecontrol";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
