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
  wireplumber,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "way-shell";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "ldelossa";
    repo = "way-shell";
    rev = "refs/tags/v${version}";
    hash = "sha256-CJSoxWqHvb2AWEhOO+plcPOU2FPsl3wR96uG9Y8sHt4=";
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
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.linux;
  };
}
