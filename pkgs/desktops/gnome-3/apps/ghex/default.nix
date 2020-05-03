{ stdenv
, fetchurl
, fetchpatch
, pkgconfig
, meson
, ninja
, python3
, gnome3
, desktop-file-utils
, appstream-glib
, gettext
, itstool
, libxml2
, gtk3
, glib
, atk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ghex";
  version = "3.18.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1h1pjrr9wynclfykizqd78dbi785wjz6b63p31k87kjvzy8w3nf2";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    atk
    glib
  ];

  checkInputs = [
    appstream-glib
    desktop-file-utils
  ];

  patches = [
    # Fixes for darwin. Drop in next release.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/ghex/commit/b0af26666cd990d99076c242b2abb3efc6e98671.patch";
      sha256 = "1zwdkgr2nqrn9q3ydyvrrpn5x55cdi747fhbq6mh6blp9cbrk9b5";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/ghex/commit/cc8ef9e67b23604c402460010dc0b5dccb85391b.patch";
      sha256 = "0j2165rfhlbrlzhmcnirqd5m89ljpz0n3nz20sxbwlc8h42zv36s";
    })
  ];

  postPatch = ''
     chmod +x meson_post_install.py
     patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "ghex";
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Ghex";
    description = "Hex editor for GNOME desktop environment";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
  };
}
