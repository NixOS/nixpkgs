{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, getconf }:

stdenv.mkDerivation rec {
  pname = "libfixposix";
  version="0.4.3";

  src = fetchFromGitHub {
    owner = "sionescu";
    repo = "libfixposix";
    rev = "v${version}";
    sha256 = "1x4q6yspi5g2s98vq4qszw4z3zjgk9l5zs8471w4d4cs6l97w08j";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ] ++ lib.optionals stdenv.isDarwin [ getconf ];

  meta = with lib; {
    homepage = "https://github.com/sionescu/libfixposix";
    description = "Thin wrapper over POSIX syscalls and some replacement functionality";
    license = licenses.boost;
    maintainers = with maintainers; [ orivej raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
