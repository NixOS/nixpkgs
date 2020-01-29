{ stdenv
, appstream
, appstream-glib
, dbus
, desktop-file-utils
, elementary-gtk-theme
, elementary-icon-theme
, fetchFromGitHub
, fetchpatch
, flatpak
, gettext
, glib
, granite
, gtk3
, json-glib
, libgee
, libsoup
, libxml2
, meson
, ninja
, packagekit
, pantheon
, pkgconfig
, python3
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "18l0kbm778728rksifslnaw2arnpr92sk24nw26k1zvs4prz5i7j";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    dbus # for pkgconfig
    desktop-file-utils
    gettext
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    appstream
    elementary-icon-theme
    elementary-gtk-theme
    flatpak
    glib
    granite
    gtk3
    json-glib
    libgee
    libsoup
    libxml2
    packagekit
  ];

  mesonFlags = [
    "-Dhomepage=false"
    "-Dpayments=false"
    "-Dcurated=false"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/elementary/appcenter;
    description = "An open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
