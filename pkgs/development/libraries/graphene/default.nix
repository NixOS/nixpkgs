{ stdenv
, fetchFromGitHub
, pkgconfig
, meson
, ninja
, python3
, mutest
, glib
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "graphene";
  version = "1.9.6";

  outputs = [ "out" "devdoc" "installedTests" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = pname;
    rev = version;
    sha256 = "0hb7s6g00l7zlf4hlfda55krn0pls9ajz0hcqrh8m656zr18ddwa";
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
    gobject-introspection
    python3
  ];

  buildInputs = [
    glib
    gobject-introspection
  ];

  checkInputs = [
    mutest
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A thin layer of graphic data types";
    homepage = "https://ebassi.github.com/graphene";
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.unix;
  };
}
