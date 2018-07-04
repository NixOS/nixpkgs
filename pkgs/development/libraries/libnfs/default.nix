{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libnfs-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    rev = "libnfs-${version}";
    sha256 = "115p55y2cbs92z5lmcnjx1v29lwinpgq4sha9v1kq1vd8674h404";
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
