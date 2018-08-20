{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson
, ninja, vala, desktop-file-utils, gtk3, granite, libgee
, geoclue2, libchamplain, clutter, folks, geocode-glib, python3
, libnotify, libical, evolution-data-server, appstream-glib
, elementary-icon-theme, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "calendar";
  version = "4.2.3";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "100wy8lkp4nrxj57ywyx44ckm3k7n8h5l6av92hr5pyx8fxn9m48";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
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
