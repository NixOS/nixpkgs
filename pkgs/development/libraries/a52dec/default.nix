{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "a52dec-0.7.4";
  
  src = fetchurl {
    url = "${meta.homepage}/files/a52dec-0.7.4.tar.gz";
    sha256 = "0czccp4fcpf2ykp16xcrzdfmnircz1ynhls334q374xknd5747d2";
  };

  NIX_CFLAGS_COMPILE = "-fpic";

  meta = {
    description = "ATSC A/52 stream decoder";
    homepage = http://liba52.sourceforge.net/;
  };
}
