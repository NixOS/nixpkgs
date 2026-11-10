{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "plexauth";
  version = "0.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jjlawren";
    repo = "python-plexauth";
    rev = "v${version}";
    hash = "sha256-T41QlTpMym2WgwvQEu/P6C0lSV4Cvrg/Etw9Nr7XxvM=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # package does not include tests
  doCheck = false;

  # at least guarantee the module can be imported
  pythonImportsCheck = [ "plexauth" ];

  meta = {
    homepage = "https://github.com/jjlawren/python-plexauth/";
    description = "Handles the authorization flow to obtain tokens from Plex.tv via external redirection";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
