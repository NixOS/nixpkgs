{ lib
, buildPythonPackage
, cherrypy
, fetchFromGitHub
, lockfile
, mock
, msgpack
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "cachecontrol";
  version = "0.12.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y15xbaqw2lxidwbyrgpy42v3cxgv4ys63fx2586h1szlrd4f3p4";
  };

  propagatedBuildInputs = [
    msgpack
    requests
  ];

  checkInputs = [
    cherrypy
    mock
    lockfile
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
