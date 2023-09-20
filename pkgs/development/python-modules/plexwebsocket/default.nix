{ lib, buildPythonPackage, fetchFromGitHub, aiohttp, isPy27 }:

buildPythonPackage rec {
  pname = "plexwebsocket";
  version = "0.0.13";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jjlawren";
    repo = "python-plexwebsocket";
    rev = "v${version}";
    hash = "sha256-u9zO3d0d4Qg+u4ezVRGkNDpJqHkYIMrEMJzBK5WKk8Y=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # package does not include tests
  doCheck = false;

  # at least guarantee the module can be imported
  pythonImportsCheck = [
    "plexwebsocket"
  ];

  meta = with lib; {
    homepage = "https://github.com/jjlawren/python-plexwebsocket/";
    description = "Async library to react to events issued over Plex websockets";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
