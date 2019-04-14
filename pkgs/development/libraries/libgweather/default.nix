{ stdenv, fetchurl, meson, ninja, pkgconfig, libxml2, glib, gtk3, gettext, libsoup
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, gobject-introspection, python3, tzdata, geocode-glib, vala, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libgweather";
  version = "3.32.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1079d26y8d2zaw9w50l9scqjhbrynpdd6kyaa32x4393f7nih8hw";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext vala gtk-doc docbook_xsl docbook_xml_dtd_43 gobject-introspection python3 ];
  buildInputs = [ glib gtk3 libsoup libxml2 geocode-glib ];

  postPatch = ''
    chmod +x meson/meson_post_install.py
    patchShebangs meson/meson_post_install.py
  '';

  mesonFlags = [
    "-Dzoneinfo_dir=${tzdata}/share/zoneinfo"
    "-Denable_vala=true"
    "-Dgtk_doc=true"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library to access weather information from online services for numerous locations";
    homepage = https://wiki.gnome.org/Projects/LibGWeather;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
