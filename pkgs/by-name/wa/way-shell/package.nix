{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  gtk4-layer-shell,
  json-glib,
  libadwaita,
  libpulseaudio,
  pipewire,
  networkmanager,
  upower,
  wayland-protocols,
  wayland-scanner,
  wireplumber,
  nix-update-script,
}:
let
  pname = "way-shell";
  version = "0.0.10";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ldelossa";
    repo = "way-shell";
    tag = "v${version}";
    hash = "sha256-x+PrgAEfG84sbvsWE2366UePKQV1YZbLojo7QrW2H2s=";
  };

  patches = [
    # fatal error: pipewire/keys.h: No such file or directory
    ./link-against-pw.patch
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    glib
    pkg-config
    wrapGAppsHook4
    wayland-scanner
  ];

  buildInputs = [
    glib
    gtk4
    gtk4-layer-shell
    json-glib
    libadwaita
    libpulseaudio
    networkmanager
    pipewire
    upower
    wayland-protocols
    wireplumber
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    make $installFlags install-gschema
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ldelossa/way-shell/releases/tag/v${version}";
    description = "GNOME-like shell for wayland compositors";
    homepage = "https://github.com/ldelossa/way-shell/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.NotAShelf ];
    platforms = lib.platforms.linux;
  };
}
