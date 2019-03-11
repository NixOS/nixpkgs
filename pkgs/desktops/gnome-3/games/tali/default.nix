{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf
, librsvg, gettext, itstool, libxml2, wrapGAppsHook
, meson, ninja, python3, desktop-file-utils
}:

stdenv.mkDerivation rec {
  name = "tali-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/tali/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0s5clkn0qm298mvphx1xdymg67w1p8vvgvypvs97k6lfjqijkx3v";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "tali"; attrPath = "gnome3.tali"; };
  };

  nativeBuildInputs = [
    meson ninja python3 desktop-file-utils
    pkgconfig gnome3.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
  ];
  buildInputs = [ gtk3 gdk_pixbuf librsvg ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Tali;
    description = "Sort of poker with dice and less money";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
