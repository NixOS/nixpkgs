{ lib, stdenv
, fetchurl
, gettext
, gobject-introspection
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, pkg-config
, meson
, ninja
, vala
, glib
, zlib
, gnome
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "gcab";
<<<<<<< HEAD
  version = "1.6";
=======
  version = "1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "bin" "out" "dev" "devdoc" "installedTests" ];

  src = fetchurl {
<<<<<<< HEAD
    url = "mirror://gnome/sources/gcab/${lib.versions.majorMinor version}/gcab-${version}.tar.xz";
    hash = "sha256-LwyWFVd8QSaQniUfneBibD7noVI3bBW1VE3xD8h+Vgs=";
=======
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Rr90QkkfqkFIJCuewqB4al9unv+xsFZuUpDozIbwDww=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # allow installing installed tests to a separate output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
    zlib
  ];

  # required by libgcab-1.0.pc
  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };

    tests = {
      installedTests = nixosTests.installed-tests.gcab;
    };
  };

  meta = with lib; {
    description = "GObject library to create cabinet files";
    homepage = "https://gitlab.gnome.org/GNOME/gcab";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
