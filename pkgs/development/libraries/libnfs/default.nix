{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libnfs";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    rev = "libnfs-${version}";
    sha256 = "sha256-rdxi5bPXHTICZQIj/CmHgZ/V70svnITJj/OSF4mmC3o=";
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
