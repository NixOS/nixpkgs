{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, vala
, desktop-file-utils
, gtk3
, granite
, libgee
, geoclue2
, libchamplain
, clutter
, folks
, geocode-glib
, python3
, libnotify
, libical
, evolution-data-server
, appstream-glib
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-calendar";
  version = "unstable-2019-10-29";

  repoName = "calendar";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "7d201fc5ea9e8dc25c46427397594fcab2016ed6"; # needed for libical 2.0 compat
    sha256 = "11bqf3nxrj1sfd0qq5h0jsmimc6mwkd2g7q9ycizn9x5ak2gb8xi";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      inherit repoName;
      attrPath = pname;
      versionPolicy = "master";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter
    elementary-icon-theme
    evolution-data-server
    folks
    geoclue2
    geocode-glib
    granite
    gtk3
    libchamplain
    libgee
    libical
    libnotify
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Desktop calendar app designed for elementary OS";
    homepage = https://github.com/elementary/calendar;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
