{ stdenv
, fetchFromGitHub
, fetchpatch
, docbook_xml_dtd_43
, docbook-xsl-nons
, glib
, json-glib
, gnutls
, gpgme
, gobject-introspection
, vala
, help2man
, gtk-doc
, meson
, ninja
, pkg-config
, python3
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "libjcat";
  version = "0.1.1";

  outputs = [ "bin" "out" "dev" "devdoc" "man" "installedTests" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libjcat";
    rev = version;
    sha256 = "hWJUzpQvy2V4pS8C/nW7Xrs9U9LQWMsGuTVOnm5UJc0=";
  };

  patches = [
    # Installed tests are installed to different output
    ./installed-tests-path.patch

    # Fix version file generation
    (fetchpatch {
      url = "https://github.com/hughsie/libjcat/commit/cf2d9298a5fab7278ee040bc0b4be384a7b5538e.patch";
      sha256 = "3749qih+wfhU8ECklh5BvReJ7pS+Ao1Q7YueZ1tT0Is=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    docbook_xml_dtd_43
    docbook-xsl-nons
    gobject-introspection
    vala
    help2man
    gtk-doc
    (python3.withPackages (pkgs: with pkgs; [
      setuptools
    ]))
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

  postPatch = ''
    patchShebangs contrib/generate-version-script.py
  '';

  doCheck = true;

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.libjcat;
    };
  };

  meta = with stdenv.lib; {
    description = "Library for reading and writing Jcat files";
    homepage = "https://github.com/hughsie/libjcat";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.all;
  };
}
