{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "mpyq";
  version = "0.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MKr1livlafPytTl4BgzQR0NO5PWiFZJd1v8P7wTsAAc=";
  };

  meta = {
    description = "Python library for extracting MPQ (MoPaQ) files";
    mainProgram = "mpyq";
    homepage = "https://github.com/eagleflo/mpyq";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
