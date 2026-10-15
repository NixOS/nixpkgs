{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "plexwebsocket";
  version = "0.0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jjlawren";
    repo = "python-plexwebsocket";
    tag = "v${version}";
    hash = "sha256-gT9RWpaR33ROs6ttjH2joNPi99Ng94Tp/R9eZY1eGZk=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Package does not include tests
  doCheck = false;

  pythonImportsCheck = [ "plexwebsocket" ];

  meta = {
    description = "Library to react to events issued over Plex websockets";
    homepage = "https://github.com/jjlawren/python-plexwebsocket/";
    changelog = "https://github.com/jjlawren/python-plexwebsocket/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
