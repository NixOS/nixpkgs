{
  stdenv,
  lib,
  fetchFromGitHub,
  desktop-file-utils,
  gettext,
  libxml2,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
  at-spi2-core,
  gnome-settings-daemon,
  gnome-desktop,
  granite,
  granite7,
  gtk3,
  gtk4,
  libgee,
  libhandy,
  mutter,
  sqlite,
  systemd,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    tag = version;
    hash = "sha256-omsAOOZCQINLTZQg3Sew+p84jv8+R2cHSVtcHFIeUBI=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    at-spi2-core
    gnome-settings-daemon
    gnome-desktop
    granite
    granite7
    gtk3 # daemon-gtk3
    gtk4
    libgee
    libhandy
    mutter
    sqlite
    systemd
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "conf.set('PLUGINDIR', plugins_dir)" "conf.set('PLUGINDIR','/run/current-system/sw/lib/gala/plugins')"
  '';

  mesonFlags = [
    # https://github.com/elementary/gala/commit/1e75d2a4b42e0d853fd474e90f1a52b0bcd0f690
    "-Dold-icon-groups=true"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "gala";
  };
}
