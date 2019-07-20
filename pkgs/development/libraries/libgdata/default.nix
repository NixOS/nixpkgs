{ stdenv
, fetchurl
, pkgconfig
, meson
, ninja
, vala
, gettext
, libxml2
, glib
, json-glib
, gcr
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
  version = "0.17.10";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "04mh2p5x2iidfx0d1cablxbi3hvna8cmlddc1mm4387n0grx3ly1";
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
    gnome3.gnome-online-accounts
    liboauth
    libsoup
    libxml2
    openssl
    p11-kit
    uhttpmock
  ];

  propagatedBuildInputs = [
    json-glib
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dinstalled_test_bindir=${placeholder ''installedTests''}/libexec"
    "-Dinstalled_test_datadir=${placeholder ''installedTests''}/share"
    "-Dinstalled_tests=true"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none"; # Stable version has not been updated for a long time.
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
