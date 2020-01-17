{ lib, buildPythonPackage, fetchPypi, requests, tqdm, websocket_client }:

buildPythonPackage rec {
  pname = "PlexAPI";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18iflcjrc9n7j1x19hfrkmxq08008w08cjrzwvgaaip8crlyp7z8";
  };

  propagatedBuildInputs = [ requests tqdm websocket_client ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pkkid/python-plexapi";
    description = "Python bindings for the Plex API";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
  };
}
