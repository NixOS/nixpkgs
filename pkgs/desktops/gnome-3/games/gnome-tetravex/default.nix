{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, libxml2, gettext, itstool, meson, ninja, python3
, vala, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-tetravex";
  version = "3.36.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tetravex/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0amnmd12mpny3vnf946wnphlsnbvjrvkx29sarplm57m1571qdc5";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-tetravex"; attrPath = "gnome3.gnome-tetravex"; };
  };

  nativeBuildInputs = [
    wrapGAppsHook itstool libxml2 gnome3.adwaita-icon-theme
    pkgconfig gettext meson ninja python3 vala desktop-file-utils
  ];
  buildInputs = [
    gtk3
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Tetravex";
    description = "Complete the puzzle by matching numbered tiles";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
