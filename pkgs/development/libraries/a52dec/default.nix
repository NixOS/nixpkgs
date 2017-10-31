{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "a52dec-0.7.4p4";
  
  src = fetchurl {
    url = "${meta.homepage}/files/a52dec-0.7.4.tar.gz";
    sha256 = "0czccp4fcpf2ykp16xcrzdfmnircz1ynhls334q374xknd5747d2";
  };

  # From Handbrake
  patches = [
    ./A00-a52-state-t-public.patch
    ./A01-thread-safe.patch
    ./A02-imdct-shutup.patch
    ./A03-automake.patch
  ];

  meta = {
    description = "ATSC A/52 stream decoder";
    homepage = http://liba52.sourceforge.net/;
    platforms = stdenv.lib.platforms.unix;
  };
}
