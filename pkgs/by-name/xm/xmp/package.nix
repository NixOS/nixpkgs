{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  alsa-lib,
  libxmp,
}:

stdenv.mkDerivation rec {
  pname = "xmp";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "xmp-cli";
    rev = "${pname}-${version}";
    hash = "sha256-037k1rFjGR6XFtr08bzs4zVz+GyUGuuutuWFlNEuATA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libxmp ] ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  meta = {
    description = "Extended module player";
    homepage = "https://xmp.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "xmp";
  };
}
