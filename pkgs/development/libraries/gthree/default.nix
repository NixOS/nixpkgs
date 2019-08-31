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
  version = "unstable-2019-08-21";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "alexlarsson";
    repo = "gthree";
    rev = "dac46b0f35e29319c004c7e17b5f345ef4c04cb8";
    sha256 = "16ixis2g04000zffm44s7ir64vn3byz9a793g2s76aasqybl86i2";
  };

  patches = [
    # correctly declare json-glib in .pc file
    # https://github.com/alexlarsson/gthree/pull/61
    (fetchpatch {
      url = https://github.com/alexlarsson/gthree/commit/784b1f20e0b6eb15f113a51f74c2cba871249861.patch;
      sha256 = "07vxafaxris5a98w751aw04nlw0l45np1lba08xd16wdzmkadz0x";
    })
  ];

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
    homepage = https://github.com/alexlarsson/gthree;
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
