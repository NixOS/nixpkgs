{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libnfs-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    rev = "libnfs-${version}";
    sha256 = "1xd1xb09jxwmx7hblv0f9gxv7i1glk3nbj2vyq50zpi158lnf2mb";
  };

  nativeBuildInputs = [ autoreconfHook ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-Wno-error=tautological-compare";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "NFS client library";
    homepage    = https://github.com/sahlberg/libnfs;
    license     = with licenses; [ lgpl2 bsd2 gpl3 ];
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
