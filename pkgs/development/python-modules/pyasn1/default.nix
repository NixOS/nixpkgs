{ stdenv, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyasn1";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb81622d8f3509f0026b0683fe90fea27be7284d3826a5f2edf97f69151ab0fc";
  };

  meta = with stdenv.lib; {
    description = "ASN.1 tools for Python";
    homepage = http://pyasn1.sourceforge.net/;
    license = "mBSD";
    platforms = platforms.unix;  # arbitrary choice
  };
}
