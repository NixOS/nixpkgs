{ lib, buildPythonPackage, fetchFromGitHub, requests
, tqdm, websocket_client, pytest, pillow, mock, isPy27 }:

buildPythonPackage rec {
  pname = "PlexAPI";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    rev = version;
    sha256 = "1rzy018zcsws56mcghnphhzwj650pwj7qg6nh9z1kjvgwwjfmghf";
  };

  propagatedBuildInputs = [ requests tqdm websocket_client ];

  checkInputs = [ pytest pillow ]
    ++ lib.optionals isPy27 [ mock ];

  meta = with lib; {
    homepage = "https://github.com/pkkid/python-plexapi";
    description = "Python bindings for the Plex API";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
  };
}
