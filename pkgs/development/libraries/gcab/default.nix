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
, git
, vala
, glib
, zlib
, gnome
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "gcab";
  version = "1.4";

  outputs = [ "bin" "out" "dev" "devdoc" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "13q43iqld4l50yra45lhvkd376pn6qpk7rkx374zn8y9wsdzm9b7";
  };

  patches = [
    # allow installing installed tests to a separate output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    git
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
    platforms = platforms.linux;
  };
}
