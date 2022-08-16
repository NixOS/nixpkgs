{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, vala
, glib
, liboauth
, gtk3
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, libxml2
, gnome
, gobject-introspection
, libsoup_3
, totem-pl-parser
}:

stdenv.mkDerivation rec {
  pname = "grilo";
  version = "0.3.15"; # if you change minor, also change ./setup-hook.sh

  outputs = [ "out" "dev" "man" "devdoc" ];
  outputBin = "dev";

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "81Ks9zZlZpk0JwY2/t5mtS2mgB/iD2OMQEirJnhXey0=";
  };

  mesonFlags = [
    "-Denable-gtk-doc=true"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
    liboauth
    gtk3
    libxml2
    libsoup_3
    totem-pl-parser
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Grilo";
    description = "Framework that provides access to various sources of multimedia content, using a pluggable system";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
