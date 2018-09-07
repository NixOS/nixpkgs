{ stdenv, fetchurl, meson, ninja, pkgconfig, libxml2, glib, gtk, gettext, libsoup
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, gobjectIntrospection, python3, tzdata, geocode-glib, vala, gnome3 }:

let
  pname = "libgweather";
  version = "3.28.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0xfy5ghwvnz2g9074dy6512m4z2pv66pmja14vhi9imgacbfh708";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext vala gtk-doc docbook_xsl docbook_xml_dtd_43 gobjectIntrospection python3 ];
  buildInputs = [ glib gtk libsoup libxml2 geocode-glib ];

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
      attrPath = "gnome3.${pname}";
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
