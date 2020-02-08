{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, glib
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "glib-testing";
  version = "0.1.0";

  outputs = [ "out" "dev" "devdoc" "installedTests" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "pwithnall";
    repo = "libglib-testing";
    rev = version;
    sha256 = "0xmycsrlqyji6sc2i4wvp2gxf3897z65a57ygihfnpjpyl7zlwkr";
  };

  patches = [
    # allow installing installed tests to a separate output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.glib-testing;
    };
  };

  meta = with stdenv.lib; {
    description = "Test library providing test harnesses and mock classes complementing the classes provided by GLib";
    homepage = "https://gitlab.gnome.org/pwithnall/libglib-testing";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
