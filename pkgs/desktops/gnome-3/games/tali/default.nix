{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk-pixbuf
, librsvg, gettext, itstool, libxml2, wrapGAppsHook
, meson, ninja, python3, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "tali";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/tali/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0knq2vwnbkzhb6yc0f8iznaz76yf5hwgg2z2xr079nz407p46v22";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "tali"; attrPath = "gnome3.tali"; };
  };

  nativeBuildInputs = [
    meson ninja python3 desktop-file-utils
    pkgconfig gnome3.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
  ];
  buildInputs = [ gtk3 gdk-pixbuf librsvg ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Tali;
    description = "Sort of poker with dice and less money";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
