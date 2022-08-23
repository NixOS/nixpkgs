{ buildPythonPackage, fetchPypi, lib }:

let
  pname = "heatshrink2";
  version = "0.11.0";

in
buildPythonPackage {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xihtHUuS+664Ow/YtfgxyTUNzRBG53blqqg9G+Q4Nfc=";
  };

  meta = {
    description = "Compression using the Heatshrink algorithm in Python 3.";
    homepage = "https://github.com/eerimoq/pyheatshrink";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
