{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libnfs-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    rev = "libnfs-${version}";
    sha256 = "0i27wd4zvhjz7620q043p4d4mkx8zv2yz9adm1byin47dynahyda";
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
