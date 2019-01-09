{ fetchurl, stdenv, meson, ninja, gettext, itstool, pkgconfig, libxml2, libjpeg, libpeas, gnome3
, gtk3, glib, gsettings-desktop-schemas, adwaita-icon-theme, gnome-desktop, lcms2, gdk_pixbuf, exempi
, shared-mime-info, wrapGAppsHook, librsvg, libexif, gobject-introspection, python3 }:

let
  pname = "eog";
  version = "3.28.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1wrq3l3z0x6q0hnc1vqr2hnyb1b14qw6aqvc5dldfgbs0yys6p55";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool wrapGAppsHook libxml2 gobject-introspection python3 ];

  buildInputs = [
    libjpeg gtk3 gdk_pixbuf glib libpeas librsvg lcms2 gnome-desktop libexif exempi
    gsettings-desktop-schemas shared-mime-info adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME image viewer";
    homepage = https://wiki.gnome.org/Apps/EyeOfGnome;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
