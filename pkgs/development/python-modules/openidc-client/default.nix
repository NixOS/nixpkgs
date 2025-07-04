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
    sha256 = "680e969cae18c30adbddd6a087ed09f6a296b4937b4c8bc69be813bdbbfa9847";
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
