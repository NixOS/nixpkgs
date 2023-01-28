{ lib
, stdenv
, fetchurl
, pkg-config
, gnome
, gtk3
, wrapGAppsHook
, librsvg
, gsound
, gettext
, itstool
, libxml2
, libgnome-games-support
, libgee
, meson
, ninja
, vala
, python3
, desktop-file-utils
, adwaita-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "gnome-robots";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "04fbykj576dq1h6cycgfhh8wd6yxmlsqykvj188sbwahay42zgvg";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    python3
    libxml2
    wrapGAppsHook
    gettext
    itstool
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    librsvg
    gsound
    libgnome-games-support
    libgee
    adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-robots";
      attrPath = "gnome.gnome-robots";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Robots";
    description = "Avoid the robots and make them crash into each other";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
