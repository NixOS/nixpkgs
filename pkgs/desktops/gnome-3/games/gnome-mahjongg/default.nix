{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, libxml2
, meson, ninja, python3, vala, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-mahjongg";
  version = "3.36.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "15xfp2acqdnn0pcwg5d77dpv758jjyclwb042wm12gg07rbg3s6j";
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
    homepage = "https://wiki.gnome.org/Apps/Mahjongg";
    description = "Disassemble a pile of tiles by removing matching pairs";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
