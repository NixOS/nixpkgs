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
<<<<<<< HEAD
  version = "8.4.0";
=======
  version = "8.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Tb6+NfJ2/WRJb3R/W8oBJ5HIT8vwQUxiwqKul2hzlXY=";
=======
    hash = "sha256-omsAOOZCQINLTZQg3Sew+p84jv8+R2cHSVtcHFIeUBI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
=======
  mesonFlags = [
    # https://github.com/elementary/gala/commit/1e75d2a4b42e0d853fd474e90f1a52b0bcd0f690
    "-Dold-icon-groups=true"
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    description = "Window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    description = "Window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gala";
  };
}
