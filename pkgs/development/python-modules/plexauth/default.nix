{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "plexauth";
  version = "0.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gzf5w1z5p24x08fincicbbi358i6ngjw5rc8k8nwy69bjrbk7r8";
  };

  propagatedBuildInputs = [ aiohttp ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jjlawren/python-plexauth/";
    description = "Handles the authorization flow to obtain tokens from Plex.tv via external redirection";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
