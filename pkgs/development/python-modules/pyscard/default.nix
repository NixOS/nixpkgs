{ stdenv, fetchurl, buildPythonPackage, swig, pcsclite, PCSC }:

buildPythonPackage rec {
  version = "1.9.7";
  pname = "pyscard";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pyscard/${name}.tar.gz";
    sha256 = "412c74c83e7401566e9d3d7b8b5ca965e74582a1f33179b3c1fabf1da73ebf80";
  };

  patchPhase = ''
    sed -e 's!"libpcsclite\.so\.1"!"${pcsclite}/lib/libpcsclite.so.1"!' \
        -i smartcard/scard/winscarddll.c
  '';

  NIX_CFLAGS_COMPILE = "-isystem ${pcsclite}/include/PCSC/";

  propagatedBuildInputs = [ pcsclite ];
  buildInputs = [ swig ] ++ stdenv.lib.optional stdenv.isDarwin PCSC;

  meta = {
    homepage = https://pyscard.sourceforge.io/;
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
