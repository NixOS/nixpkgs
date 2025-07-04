{
  lib,
  stdenv,
  fetchFromGitHub,

  makeWrapper,
  pkg-config,

  gtkmm4,
  curl,
  gtk4-layer-shell,
  jsoncpp,
  dbus,
  wireplumber,
  playerctl,
  libnl,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysbar";
  version = "0-unstable-2025-05-02";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "sysbar";
    rev = "7040925b06617aabd9f8837fd4f9370bd45ae4c8";
    hash = "sha256-hWqzgWMcae8/SGcNZgpqF2dFPT5t6K4GHX2/apOxZHE=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    gtkmm4
    curl
    gtk4-layer-shell
    jsoncpp
    dbus
    wireplumber
    playerctl
    libnl
    wayland-scanner
  ];

  NIX_CFLAGS_COMPILE = [ "-I${libnl.dev}/include/libnl3" ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    # Wrap the sysbar binary to include its own lib directory in
    # LD_LIBRARY_PATH.  Please see:
    # https://github.com/System64fumo/sysbar/issues/6
    wrapProgram $out/bin/sysbar \
      --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  meta = {
    description = "Modular status bar for wayland";
    homepage = "https://github.com/System64fumo/sysbar";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "sysbar";
    platforms = lib.platforms.linux;
  };
})
