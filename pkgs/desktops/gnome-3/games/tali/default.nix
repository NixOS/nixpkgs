{ lib, stdenv, fetchurl, pkg-config, gtk3, gnome3, gdk-pixbuf
, librsvg, libgnome-games-support, gettext, itstool, libxml2, wrapGAppsHook
, meson, ninja, python3, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "tali";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/tali/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "19gic6yjg3bg6jf87zvhm7ihsz1y58dz86p4x3a16xdhjyrk40q2";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "tali"; attrPath = "gnome3.tali"; };
  };

  nativeBuildInputs = [
    meson ninja python3 desktop-file-utils
    pkg-config gnome3.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
  ];
  buildInputs = [ gtk3 gdk-pixbuf librsvg libgnome-games-support ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Tali";
    description = "Sort of poker with dice and less money";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
