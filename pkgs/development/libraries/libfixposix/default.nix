{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name="libfixposix-${version}";
  version="0.4.3";

  src = fetchFromGitHub {
    owner = "sionescu";
    repo = "libfixposix";
    rev = "v${version}";
    sha256 = "1x4q6yspi5g2s98vq4qszw4z3zjgk9l5zs8471w4d4cs6l97w08j";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sionescu/libfixposix;
    description = "Thin wrapper over POSIX syscalls and some replacement functionality";
    license = licenses.boost;
    maintainers = with maintainers; [ orivej raskin ];
    platforms = platforms.linux;
  };
}
