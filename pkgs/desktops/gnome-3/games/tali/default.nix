{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk-pixbuf
, librsvg, libgnome-games-support, gettext, itstool, libxml2, wrapGAppsHook
, meson, ninja, python3, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "tali";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/tali/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "196f6hiap61sdqr7kvywk74yl0m2j7fvqml37p6cgfm7gfrhrvi9";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "tali"; attrPath = "gnome3.tali"; };
  };

  nativeBuildInputs = [
    meson ninja python3 desktop-file-utils
    pkgconfig gnome3.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
  ];
  buildInputs = [ gtk3 gdk-pixbuf librsvg libgnome-games-support ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Tali";
    description = "Sort of poker with dice and less money";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
