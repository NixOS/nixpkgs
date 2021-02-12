{ lib, stdenv
, fetchurl
, pkg-config
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
  version = "0.18.0";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "8MIBEvpTcrYsASVvJorvUTGhYd/COGjzk+z3uLN1JYA=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
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

  meta = with lib; {
    description = "GData API library";
    homepage = "https://wiki.gnome.org/Projects/libgdata";
    maintainers = with maintainers; [ raskin lethalman ] ++ teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
