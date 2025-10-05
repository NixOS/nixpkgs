{
  lib,
  stdenv,
  fetchFromGitHub,
  inih,
  meson,
  ninja,
  pkg-config,
  cmocka,
  scdoc,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libseccomp,
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "francma";
    repo = "wob";
    rev = version;
    sha256 = "sha256-Bn/WN9Ix4vm9FDFVKc/vRLP4WeVNaJFz1WBuS9tqJhY=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    cmocka
    inih
    wayland
    wayland-protocols
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libseccomp;

  mesonFlags = lib.optional stdenv.hostPlatform.isLinux "-Dseccomp=enabled";

  meta = {
    inherit (src.meta) homepage;
    description = "Lightweight overlay bar for Wayland";
    longDescription = ''
      A lightweight overlay volume/backlight/progress/anything bar for Wayland,
      inspired by xob.
    '';
    changelog = "https://github.com/francma/wob/releases/tag/${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    mainProgram = "wob";
  };
}
