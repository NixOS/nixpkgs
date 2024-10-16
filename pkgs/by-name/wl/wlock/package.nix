{
  lib,
  stdenv,
  fetchFromGitea,
  libxcrypt,
  pkg-config,
  wayland,
  wayland-protocols,
  libxkbcommon,
  wayland-scanner,
}:
stdenv.mkDerivation rec {
  pname = "wlock";
  version = "0-unstable-2024-09-13";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "wlock";
    rev = "be975445fa0da7252f8e13b610c518dd472652d0";
    hash = "sha256-Xt7Q51RhFG+UXYukxfORIhc4Df86nxtpDhAhaSmI38A=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail 'chmod 4755' 'chmod 755'
  '';

  buildInputs = [
    libxcrypt
    wayland
    wayland-protocols
    libxkbcommon
  ];

  strictDeps = true;

  makeFlags = [
    "PREFIX=$(out)"
    ("WAYLAND_SCANNER=" + lib.getExe wayland-scanner)
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  meta = {
    description = "Sessionlocker for Wayland compositors that support the ext-session-lock-v1 protocol";
    license = lib.licenses.gpl3;
    homepage = "https://codeberg.org/sewn/wlock";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fliegendewurst ];
  };
}
