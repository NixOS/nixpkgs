{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gnome3
, glib
, gtk3
, cairo
, wrapGAppsHook
, libxml2
, python3
, gettext
, itstool
, desktop-file-utils
, adwaita-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "hitori";
  version = "3.31.92";

  src = fetchurl {
    url = "mirror://gnome/sources/hitori/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0m2w3zz6v1bsd1fn78ab79d72ywd9vq60rziazsblxsi4qy9dva5";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    itstool
    desktop-file-utils
    libxml2
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    cairo
    adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Hitori;
    description = "GTK+ application to generate and let you play games of Hitori";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
