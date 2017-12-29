{ stdenv, fetchurl, buildPythonPackage, swig, pcsclite }:

buildPythonPackage rec {
  version = "1.9.5";
  pname = "pyscard";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pyscard/${name}.tar.gz";
    sha256 = "7eef027e1939b7595fc13c03616f262f90d118594fdb6f7620af46b54fa06835";
  };

  patchPhase = ''
    sed -e 's!"libpcsclite\.so\.1"!"${pcsclite}/lib/libpcsclite.so.1"!' \
        -i smartcard/scard/winscarddll.c
  '';

  NIX_CFLAGS_COMPILE = "-isystem ${pcsclite}/include/PCSC/";

  propagatedBuildInputs = [ pcsclite ];
  buildInputs = [ swig ];

  meta = {
    homepage = https://pyscard.sourceforge.io/;
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
