{ stdenv, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f58f2a3d12fd754aa123e9fa74fb7345333000a035f3921dbdaa08597aa53137";
  };

  meta = with stdenv.lib; {
    description = "ASN.1 tools for Python";
    homepage = http://pyasn1.sourceforge.net/;
    license = "mBSD";
    platforms = platforms.unix;  # arbitrary choice
  };
}
