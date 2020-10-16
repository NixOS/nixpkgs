{ lib, buildPythonPackage, fetchFromGitHub, aiohttp, isPy27 }:

buildPythonPackage rec {
  pname = "plexwebsocket";
  version = "0.0.12";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jjlawren";
    repo = "python-plexwebsocket";
    rev = "v${version}";
    sha256 = "1xdzb268c71yb25a5mk4g2jrbq4dv8bynfirs7p4n8a51p030dz6";
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
