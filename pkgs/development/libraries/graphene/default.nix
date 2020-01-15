{ stdenv
, fetchFromGitHub
, pkgconfig
, meson
, ninja
, python3
, mutest
, nixosTests
, glib
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "graphene";
  version = "1.10.0";

  outputs = [ "out" "devdoc" "installedTests" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = pname;
    rev = version;
    sha256 = "16vqwih5bfxv7r3mm7iiha804rpsxzxjfrs4kx76d9q5yg2hayxr";
  };

  patches = [
    ./0001-meson-add-options-for-tests-installation-dirs.patch
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dinstalled_test_datadir=${placeholder "installedTests"}/share"
    "-Dinstalled_test_bindir=${placeholder "installedTests"}/libexec"
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

  passthru = {
    tests = {
      installedTests = nixosTests.graphene;
    };
  };

  meta = with stdenv.lib; {
    description = "A thin layer of graphic data types";
    homepage = "https://ebassi.github.com/graphene";
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.unix;
  };
}
