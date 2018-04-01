{ stdenv, fetchurl, meson, ninja, pkgconfig, libxml2, glib, gtk, gettext, libsoup
, gtk-doc, docbook_xsl, gobjectIntrospection, tzdata, geocode-glib, vala, gnome3 }:

let
  pname = "libgweather";
  version = "3.28.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1qqbfgmlfs0g0v92rdl96v2b44yr3sqj9x7zpqv1nx9aaf486yhm";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext vala gtk-doc docbook_xsl gobjectIntrospection ];
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
