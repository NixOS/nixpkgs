{ stdenv, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyasn1";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d258b0a71994f7770599835249cece1caef3c70def868c4915e6e5ca49b67d15";
  };

  meta = with stdenv.lib; {
    description = "ASN.1 tools for Python";
    homepage = http://pyasn1.sourceforge.net/;
    license = "mBSD";
    platforms = platforms.unix;  # arbitrary choice
  };
}
