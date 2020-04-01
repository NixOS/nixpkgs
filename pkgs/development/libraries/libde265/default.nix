{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.0.5";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    rev = "v${version}";
    sha256 = "1qisj8ryzbknam3hk81rq70fsd9mcpxm898bqygvbsmbwyvmz3pg";
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
