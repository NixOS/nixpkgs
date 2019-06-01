{ stdenv
, fetchFromGitHub
, pkgconfig
, meson
, ninja
, python3
, glib
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "graphene";
  version = "1.9.2";

  outputs = [ "out" "devdoc" "installedTests" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = pname;
    rev = version;
    sha256 = "00rajaxj6642pcn34is2wrb4sxs8axw1iqw2dngglp1k7wns8x92";
  };

  patches = [
    ./0001-meson-add-options-for-tests-installation-dirs.patch
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dinstalled_test_datadir=${placeholder ''installedTests''}/share"
    "-Dinstalled_test_bindir=${placeholder ''installedTests''}/libexec"
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    gtk-doc
    meson
    ninja
    pkgconfig
    python3
  ];

  buildInputs = [
    gobject-introspection
  ];

  checkInputs = [
    glib
  ];

  meta = with stdenv.lib; {
    description = "A thin layer of graphic data types";
    homepage = "https://ebassi.github.com/graphene";
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.unix;
  };
}
