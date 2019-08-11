{ stdenv, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7";
  };

  meta = with stdenv.lib; {
    description = "ASN.1 tools for Python";
    homepage = http://pyasn1.sourceforge.net/;
    license = "mBSD";
    platforms = platforms.unix;  # arbitrary choice
  };
}
