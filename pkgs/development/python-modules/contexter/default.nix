{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "contexter";
  version = "0.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c730890b1a915051414a6350d8ea1cddca7d01d8f756badedb30b9bf305ea0a8";
  };

  meta = with lib; { };
}
