{
  lib,
  stdenv,
  fetchFromCodeberg,
  pkg-config,
  libx11,
  libxft,
  libxinerama,
  fontconfig,
}:
stdenv.mkDerivation {
  pname = "vxwm";
  version = "2.3-unstable-2026-08-08";

  src = fetchFromCodeberg {
    owner = "wh1tepearl";
    repo = "vxwm";
    rev = "e3c929a622f87a4463fd1feb99dd3faf3acd3f55";
    hash = "sha256-W7BYpvU1oBfHN3QzZDvDhWVEQ4w/1hKRFdiDzpqfhJ8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libx11
    libxft
    libxinerama
    fontconfig
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "MANPREFIX=$(out)/share/man"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Versatile X Window Manager for X11 forked from dwm";
    homepage = "https://codeberg.org/wh1tepearl/vxwm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dmkhitaryan ];
    platforms = lib.platforms.linux;
    mainProgram = "vxwm";
  };
}
