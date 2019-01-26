{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "a52dec-0.7.4p4";

  src = fetchurl {
    url = "${meta.homepage}/files/a52dec-0.7.4.tar.gz";
    sha256 = "0czccp4fcpf2ykp16xcrzdfmnircz1ynhls334q374xknd5747d2";
  };

  configureFlags = [
    "--enable-shared"
  ];

  # fails 1 out of 1 tests with "BAD GLOBAL SYMBOLS" on i686
  # which can also be fixed with
  # hardeningDisable = stdenv.lib.optional stdenv.isi686 "pic";
  # but it's better to disable tests than loose ASLR on i686
  doCheck = !stdenv.isi686;

  meta = {
    description = "ATSC A/52 stream decoder";
    homepage = http://liba52.sourceforge.net/;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2;
  };
}
