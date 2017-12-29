{ stdenv, fetchurl, buildPythonPackage, swig, pcsclite, PCSC }:

buildPythonPackage rec {
  version = "1.9.6";
  pname = "pyscard";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pyscard/${name}.tar.gz";
    sha256 = "6e28143c623e2b34200d2fa9178dbc80a39b9c068b693b2e6527cdae784c6c12";
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
