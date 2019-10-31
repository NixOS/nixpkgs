{ stdenv
, fetchFromGitHub
, fetchpatch
, ninja
, meson
, pkgconfig
, gobject-introspection
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, glib
, gtk3
, graphene
, epoxy
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gthree";
  version = "0.2.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "alexlarsson";
    repo = "gthree";
    rev = version;
    sha256 = "16ap1ampnzsyhrs84b168d6889lh8sjr2j5sqv9mdbnnhy72p5cd";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkgconfig
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    epoxy
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    graphene
    json-glib
  ];

  mesonFlags = [
    "-Dgtk_doc=${if stdenv.isDarwin then "false" else "true"}"
  ];

  meta = with stdenv.lib; {
    description = "GObject/GTK port of three.js";
    homepage = "https://github.com/alexlarsson/gthree";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
