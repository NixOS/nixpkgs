{ lib, buildPythonPackage, fetchFromGitHub, requests
, tqdm, websocket_client, pytest, pillow, isPy27 }:

buildPythonPackage rec {
  pname = "PlexAPI";
  version = "4.1.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    rev = version;
    sha256 = "1l955q1q6lljq3bmyiayr33gzxrlw16xdwgjdaflznvyg16fcjkk";
  };

  propagatedBuildInputs = [ requests tqdm websocket_client ];

  checkInputs = [ pytest pillow ];

  meta = with lib; {
    homepage = "https://github.com/pkkid/python-plexapi";
    description = "Python bindings for the Plex API";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
  };
}
