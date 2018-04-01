{ fetchurl, stdenv, meson, ninja, gettext, itstool, pkgconfig, libxml2, libjpeg, libpeas, gnome3
, gtk3, glib, gsettings-desktop-schemas, adwaita-icon-theme, gnome-desktop, lcms2, gdk_pixbuf, exempi
, shared-mime-info, wrapGAppsHook, librsvg, libexif, gobjectIntrospection }:

let
  pname = "eog";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0d8fi5ydsh8n7d85dps8svl1bhid1p8jbnlwiqywj2gd2wpxpyjv";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool wrapGAppsHook libxml2 gobjectIntrospection ];

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
