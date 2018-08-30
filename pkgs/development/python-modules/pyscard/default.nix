{ stdenv, fetchPypi, buildPythonPackage, swig, pcsclite, PCSC }:

buildPythonPackage rec {
  version = "1.9.7";
  pname = "pyscard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "412c74c83e7401566e9d3d7b8b5ca965e74582a1f33179b3c1fabf1da73ebf80";
  };

  postPatch = ''
    sed -e 's!"libpcsclite\.so\.1"!"${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so.1"!' \
        -i smartcard/scard/winscarddll.c
  '';

  NIX_CFLAGS_COMPILE = "-isystem ${stdenv.lib.getDev pcsclite}/include/PCSC/";

  propagatedBuildInputs = [ pcsclite ];
  buildInputs = [ swig ] ++ stdenv.lib.optional stdenv.isDarwin PCSC;

  meta = {
    homepage = https://pyscard.sourceforge.io/;
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
