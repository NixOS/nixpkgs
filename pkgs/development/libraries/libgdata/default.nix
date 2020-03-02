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
, gnome3
, p11-kit
, openssl
, uhttpmock
, libsoup
}:

stdenv.mkDerivation rec {
  pname = "libgdata";
  version = "0.17.12";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0613nihsvwvdnmlbjnwi8zqxgmpwyxdapzznq4cy1fp84246zzd0";
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
      installedTests = nixosTests.installed-tests.libgdata;
    };
  };

  meta = with stdenv.lib; {
    description = "GData API library";
    homepage = "https://wiki.gnome.org/Projects/libgdata";
    maintainers = with maintainers; [ raskin lethalman ] ++ gnome3.maintainers;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
