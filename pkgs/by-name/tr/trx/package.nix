{ lib, stdenv, fetchurl, alsa-lib, libopus, ortp, bctoolbox }:

stdenv.mkDerivation rec {
  pname = "trx";
  version = "0.5";

  src = fetchurl {
    url = "https://www.pogo.org.uk/~mark/trx/releases/${pname}-${version}.tar.gz";
    sha256 = "1jjgca92nifjhcr3n0fmpfr6f5gxlqyal2wmgdlgd7hx834r1if7";
  };

  # Makefile is currently missing -lbctoolbox so the build fails when linking
  # the libraries. This patch adds that flag.
  patches = [
    ./add_bctoolbox_ldlib.patch
  ];

  buildInputs = [ alsa-lib libopus ortp bctoolbox ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple toolset for broadcasting live audio using RTP/UDP and Opus";
    homepage = "http://www.pogo.org.uk/~mark/trx/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.hansjoergschurr ];
    platforms = platforms.linux;
  };
}
