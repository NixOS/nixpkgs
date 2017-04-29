{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name="libfixposix-${version}";
  version="0.4.1";

  src = fetchFromGitHub {
    owner = "sionescu";
    repo = "libfixposix";
    rev = "v${version}";
    sha256 = "19wjb43mn16f4lin5a2dfi3ym2hy7kqibs0z631d205b16vxas15";
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
