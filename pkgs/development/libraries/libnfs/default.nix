{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libnfs";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    rev = "libnfs-${version}";
    sha256 = "sha256-5jyY7hqEhBPiQ8pNd+mRTEc4brht4ID7PoV7O2RFNQA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=tautological-compare";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "NFS client library";
    homepage    = "https://github.com/sahlberg/libnfs";
    license     = with licenses; [ lgpl2 bsd2 gpl3 ];
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
