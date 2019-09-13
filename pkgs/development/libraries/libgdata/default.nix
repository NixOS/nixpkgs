{ stdenv
, fetchurl
, pkgconfig
, meson
, ninja
, nixosTests
, vala
, gettext
, libxml2
, glib
, json-glib
, gcr
, gnome-online-accounts
, gobject-introspection
, liboauth
, gnome3
, p11-kit
, openssl
, uhttpmock
, libsoup
}:

stdenv.mkDerivation rec {
  pname = "libgdata";
  version = "0.17.11";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "11m99sh2k679rnsvqsi95s1l0r8lkvj61dmwg1pnxvsd5q91g6bb";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    gcr
    glib
    liboauth
    libsoup
    libxml2
    openssl
    p11-kit
    uhttpmock
  ];

  propagatedBuildInputs = [
    gnome-online-accounts
    json-glib
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dinstalled_test_bindir=${placeholder "installedTests"}/libexec"
    "-Dinstalled_test_datadir=${placeholder "installedTests"}/share"
    "-Dinstalled_tests=true"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none"; # Stable version has not been updated for a long time.
    };

    tests = {
      installedTests = nixosTests.libgdata;
    };
  };

  meta = with stdenv.lib; {
    description = "GData API library";
    homepage = https://wiki.gnome.org/Projects/libgdata;
    maintainers = with maintainers; [ raskin lethalman ] ++ gnome3.maintainers;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
