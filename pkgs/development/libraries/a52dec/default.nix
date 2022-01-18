{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "a52dec";
  version = "0.7.4";

  src = fetchurl {
    url = "https://liba52.sourceforge.io/files/${pname}-${version}.tar.gz";
    sha256 = "oh1ySrOzkzMwGUNTaH34LEdbXfuZdRPu9MJd5shl7DM=";
  };

  configureFlags = [
    "--enable-shared"
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  # fails 1 out of 1 tests with "BAD GLOBAL SYMBOLS" on i686
  # which can also be fixed with
  # hardeningDisable = lib.optional stdenv.isi686 "pic";
  # but it's better to disable tests than loose ASLR on i686
  doCheck = !stdenv.isi686;

  meta = with lib; {
    description = "ATSC A/52 stream decoder";
    homepage = "https://liba52.sourceforge.io/";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
