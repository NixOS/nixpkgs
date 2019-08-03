{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, libxml2
, meson, ninja, python3, vala, desktop-file-utils
}:

stdenv.mkDerivation rec {
  name = "gnome-mahjongg-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "12kamxnxbh26k4iykhbs873mx25a2wrjnhr013lfkwbyl52kg12j";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-mahjongg"; attrPath = "gnome3.gnome-mahjongg"; };
  };

  nativeBuildInputs = [
    meson ninja vala python3 desktop-file-utils
    pkgconfig gnome3.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
  ];
  buildInputs = [
    gtk3 librsvg
  ];

  postPatch = ''
    chmod +x data/meson_post_install.py
    patchShebangs data/meson_post_install.py
  '';


  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Mahjongg;
    description = "Disassemble a pile of tiles by removing matching pairs";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
