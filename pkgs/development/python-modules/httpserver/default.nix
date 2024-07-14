{
  lib,
  fetchPypi,
  buildPythonPackage,
  docopt,
}:

buildPythonPackage rec {
  pname = "httpserver";
  version = "1.1.0";
  format = "setuptools";

  buildInputs = [ docopt ];

  # Tests pull in lots of other dependencies to emulate different web
  # drivers.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W8Pa+CUS8vCzEcymjY6no5GMdSDSZs4bhmDtRsR4wuA=";
  };

  meta = {
    description = "Asyncio implementation of an HTTP server";
    mainProgram = "httpserver";
    homepage = "https://github.com/thomwiggers/httpserver";
    license = with lib.licenses; [ bsd3 ];
  };
}
