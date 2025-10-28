{
  lib,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  which,
  python3,
  wayland,
  wayland-scanner,
  wayland-protocols,
  libarchive,
  uthash,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wl-shimeji";
  version = "0.0.2-unstable-2025-10-28";

  src = fetchFromGitHub {
    owner = "CluelessCatBurger";
    repo = "wl_shimeji";
    rev = "bf0150a313c3df271d249d3e14a17b48193f67e8";
    hash = "sha256-ag3MHyyfo+2yZxPSBZgBsVZ4a6nLSv1KMUcYS34lIiM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    which
    python3
  ];
  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
    uthash
    libarchive
    (python3.withPackages (ps: [ ps.pillow ]))
  ];

  outputs = [
    "out"
    "dev"
  ];

  installFlags = [
    "PREFIX=$(out)"
  ];

  postPatch = ''
    substituteInPlace systemd/wl_shimeji.service \
      --replace-fail "/usr/bin" "$out"
  '';

  meta = {
    description = "Shimeji reimplementation for Wayland in C";
    homepage = "https://github.com/CluelessCatBurger/wl_shimeji/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ readf0x ];
    platforms = lib.platforms.linux;
  };
})
