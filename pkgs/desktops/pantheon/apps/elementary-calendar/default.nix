{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, clutter
, evolution-data-server
, folks
, geoclue2
, geocode-glib
, granite
, gtk3
, libchamplain
, libgee
, libhandy
, libical
}:

stdenv.mkDerivation rec {
  pname = "elementary-calendar";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calendar";
    rev = version;
    sha256 = "sha256-c2c8QNifBDzb0CelB72AIL4G694l6KCSXBjWIHrzZJo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter
    evolution-data-server
    folks
    geoclue2
    geocode-glib
    granite
    gtk3
    libchamplain
    libgee
    libhandy
    libical
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Desktop calendar app designed for elementary OS";
    homepage = "https://github.com/elementary/calendar";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.calendar";
  };
}
