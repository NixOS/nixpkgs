{ stdenv, fetchurl, pkgconfig, gnome3, intltool, itstool, gtk3
, wrapGAppsHook, librsvg, libxml2, desktop-file-utils
, guile_2_0, libcanberra-gtk3 }:

stdenv.mkDerivation rec {
  name = "aisleriot-${version}";
  version = "3.22.5";

  src = fetchurl {
    url = "mirror://gnome/sources/aisleriot/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0rl39psr5xi584310pyrgw36ini4wn7yr2m1q5118w3a3v1dkhzh";
  };

  configureFlags = [
    "--with-card-theme-formats=svg"
    "--with-platform=gtk-only" # until they remove GConf
  ];

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook libxml2 desktop-file-utils ];
  buildInputs = [ gtk3 librsvg guile_2_0 libcanberra-gtk3 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "aisleriot";
      attrPath = "gnome3.aisleriot";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Aisleriot;
    description = "A collection of patience games written in guile scheme";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
