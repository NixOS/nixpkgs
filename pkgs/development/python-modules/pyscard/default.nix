{ stdenv, fetchurl, fetchpatch, python, buildPythonPackage, swig, pcsclite }:

buildPythonPackage rec {
  name = "pyscard-1.9.4";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/p/pyscard/${name}.tar.gz";
    sha256 = "0gn0p4p8dhk99g8vald0dcnh45jbf82bj72n4djyr8b4hawkck4v";
  };

  configurePhase = "";


  LDFLAGS="-L${pcsclite}/lib";
  CFLAGS="-I${pcsclite}/include/PCSC";

  propagatedBuildInputs = [ swig pcsclite ];

  #doCheck = !(python.isPypy or stdenv.isDarwin); # error: AF_UNIX path too long

  meta = {
    homepage = "https://pyscard.sourceforge.io/";
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
  };
}
