{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.0.6";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    rev = "v${version}";
    sha256 = "0ipccyavlgf7hfzx1g8bvzg62xq10vcxvwgq70r3z3j6mdvmrzjp";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/strukturag/libde265";
    description = "Open h.265 video codec implementation";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ gebner ];
  };

}
