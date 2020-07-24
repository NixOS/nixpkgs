{ lib, buildPythonPackage, fetchFromGitHub, aiohttp, isPy27 }:

buildPythonPackage rec {
  pname = "plexauth";
  version = "0.0.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jjlawren";
    repo = "python-plexauth";
    rev = "v${version}";
    sha256 = "1wbrn22iywl4ccz64r3w3f17k0r7vi2cqkqd2mrdkx5xqhscn9hz";
  };

  propagatedBuildInputs = [ aiohttp ];

  # package does not include tests
  doCheck = false;

  # at least guarantee the module can be imported
  pythonImportsCheck = [
    "plexauth"
  ];

  meta = with lib; {
    homepage = "https://github.com/jjlawren/python-plexauth/";
    description = "Handles the authorization flow to obtain tokens from Plex.tv via external redirection";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
