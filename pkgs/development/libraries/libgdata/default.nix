{ stdenv
, fetchurl
, fetchpatch
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
    (fetchpatch {
      # Meson fixes
      url = "https://gitlab.gnome.org/GNOME/libgdata/commit/f6d0e3f3b6fa8e8ee9569372c5709c1fb84af2c1.diff";
      sha256 = "00yrppn0s21i41r9mwzvrrv7j5dida09kh7i44kv8hrbrlfag7bm";
    })
    (fetchpatch {
      # Meson minor fixes
      url = "https://gitlab.gnome.org/GNOME/libgdata/commit/b653f602b3c2b518101c5d909e1651534c22757a.diff";
      sha256 = "1bn0rffsvkzjl59aw8dmq1wil58x1fshz0m6xabpn79ffvbjld8j";
    })
    (fetchpatch {
      # Meson: Fix G_LOG_DOMAIN
      url = "https://gitlab.gnome.org/GNOME/libgdata/commit/5d318e0bf905d0f1a8b3fe1e47ee7847739082e3.diff";
      sha256 = "11i2blq811d53433kdq4hhsscgkrq5f50d9ih4ixgs3j47hg7b1w";
    })
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
    gnome3.gnome-online-accounts
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
