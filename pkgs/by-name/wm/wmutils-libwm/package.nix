{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
}:

stdenv.mkDerivation rec {
  pname = "wmutils-libwm";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "wmutils";
    repo = "libwm";
    rev = "v${version}";
    sha256 = "1lpbqrilhffpzc0b7vnp08jr1wr96lndwc7y0ck8hlbzlvm662l0";
  };

  buildInputs = [ libxcb ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Small library for X window manipulation";
    homepage = "https://github.com/wmutils/libwm";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ bhougland ];
    platforms = lib.platforms.unix;
  };
}
