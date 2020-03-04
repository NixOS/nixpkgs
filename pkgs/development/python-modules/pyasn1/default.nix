{ stdenv, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba";
  };

  meta = with stdenv.lib; {
    description = "ASN.1 tools for Python";
    homepage = http://pyasn1.sourceforge.net/;
    license = "mBSD";
    platforms = platforms.unix;  # arbitrary choice
  };
}
