{ stdenv, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyasn1";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06hhy38jhwh95gpn8f03cr439273fsfsh4vhd5024r86nh5gyiir";
  };

  meta = with stdenv.lib; {
    description = "ASN.1 tools for Python";
    homepage = http://pyasn1.sourceforge.net/;
    license = "mBSD";
    platforms = platforms.unix;  # arbitrary choice
  };
}
