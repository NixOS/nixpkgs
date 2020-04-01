{ stdenv
, fetchurl
, substituteAll
, meson
, ninja
, nixosTests
, pkgconfig
, glib
, gettext
, makeWrapper
, python3
, gnutls
, p11-kit
, libproxy
, gnome3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "glib-networking";
  version = "2.62.3";

  outputs = [ "out" "installedTests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1xvzixzwwh8wk8f79qbm2gl7hp3hj1a7skv281v5qsx74dpzi8cc";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-gsettings.patch;
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
    })

    ./installed-tests-path.patch
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    makeWrapper
    python3 # for install_script
  ];

  buildInputs = [
    glib
    gnutls
    p11-kit
    libproxy
    gsettings-desktop-schemas
  ];

  doCheck = false; # tests need to access the certificates (among other things)

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  postFixup = ''
    find "$installedTests/libexec" "$out/libexec" -type f -executable -print0 \
      | while IFS= read -r -d "" file; do
      echo "Wrapping program '$file'"
      wrapProgram "$file" --prefix GIO_EXTRA_MODULES : "$out/lib/gio/modules"
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };

    tests = {
      installedTests = nixosTests.installed-tests.glib-networking;
    };
  };

  meta = with stdenv.lib; {
    description = "Network-related giomodules for glib";
    homepage = https://gitlab.gnome.org/GNOME/glib-networking;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
