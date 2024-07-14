{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "csscompressor";
  version = "0.9.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r6IrrbzzEgpPOS5NIvn/9IXARKH+2kqVDsxeup3TGgU=";
  };

  doCheck = false; # No tests

  meta = with lib; {
    description = "Python port of YUI CSS Compressor";
    homepage = "https://pypi.python.org/pypi/csscompressor";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
