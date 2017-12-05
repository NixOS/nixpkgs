{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "csscompressor";
  version = "0.9.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e12f125b88379d7b680636d94a3c8fa14bed1de2358f7f9a9e6749e222cff3b";
  };

  doCheck = false; # No tests

  meta = {
    description = "A python port of YUI CSS Compressor";
    homepage = https://pypi.python.org/pypi/csscompressor;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.ahmedtd];
  };
}
