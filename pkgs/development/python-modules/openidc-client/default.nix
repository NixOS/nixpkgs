{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "openidc-client";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aA6WnK4Ywwrb3dagh+0J9qKWtJN7TIvGm+gTvbv6mEc=";
  };
  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    description = "CLI python OpenID Connect client with token caching and management";
    homepage = "https://github.com/puiterwijk";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler ];
  };
}
