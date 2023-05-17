{ stdenv
, lib
, fetchFromGitHub
, docbook_xml_dtd_43
, docbook-xsl-nons
, glib
, json-glib
, gnutls
, gpgme
, gobject-introspection
, vala
, gtk-doc
, meson
, ninja
, pkg-config
, python3
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "libjcat";
  version = "0.1.13";

  outputs = [ "bin" "out" "dev" "devdoc" "man" "installedTests" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libjcat";
    rev = version;
    sha256 = "sha256-VfI40dfZzNqR5sqTY4KvkYL8+3sLV0Z0u7w+QA34uek=";
  };

  patches = [
    # Installed tests are installed to different output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    docbook_xml_dtd_43
    docbook-xsl-nons
    gobject-introspection
    vala
    gnutls
    gtk-doc
    python3
  ];

  buildInputs = [
    glib
    json-glib
    gnutls
    gpgme
  ];

  mesonFlags = [
    "-Dgtkdoc=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  doCheck = true;

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.libjcat;
    };
  };

  meta = with lib; {
    description = "Library for reading and writing Jcat files";
    homepage = "https://github.com/hughsie/libjcat";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
