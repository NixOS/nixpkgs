{ stdenv, fetchurl, buildPythonPackage, swig, pcsclite }:

buildPythonPackage rec {
  name = "pyscard-${version}";
  version = "1.9.4";

  src = fetchurl {
    url = "mirror://pypi/p/pyscard/${name}.tar.gz";
    sha256 = "0gn0p4p8dhk99g8vald0dcnh45jbf82bj72n4djyr8b4hawkck4v";
  };

  patchPhase = ''
    sed -e 's!"libpcsclite\.so\.1"!"${pcsclite}/lib/libpcsclite.so.1"!' \
        -i smartcard/scard/winscarddll.c
  '';

  NIX_CFLAGS_COMPILE = "-isystem ${pcsclite}/include/PCSC/";

  propagatedBuildInputs = [ pcsclite ];
  buildInputs = [ swig ];

  meta = {
    homepage = "https://pyscard.sourceforge.io/";
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
