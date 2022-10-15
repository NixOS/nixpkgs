{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
, geocode-glib_2
, granite
, gtk3
, libchamplain_libsoup3
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

  patches = [
    # build: support evolution-data-server 3.46
    # https://github.com/elementary/calendar/pull/758
    (fetchpatch {
      url = "https://github.com/elementary/calendar/commit/62c20e5786accd68b96c423b04e32c043e726cac.patch";
      sha256 = "sha256-xatxoSwAIHiUA03vvBdM8HSW27vhPLvAxEuGK0gLiio=";
    })

    # GridDay: Fix day in month in grid with GLib 2.73.1+
    # https://github.com/elementary/calendar/pull/763
    (fetchpatch {
      url = "https://github.com/elementary/calendar/commit/20b0983c85935bedef065b786ec8bbca55ba7d9e.patch";
      sha256 = "sha256-Tw9uNqqRAC+vOp7EWzZVeDmZxt3hTGl9UIP21FcunqA=";
    })
  ];

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
    geocode-glib_2
    granite
    gtk3
    libchamplain_libsoup3
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
