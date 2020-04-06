{ stdenv, fetchurl, pkgconfig, gettext, libtool, libxml2, libcanberra-gtk3, gtk3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-media";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1d5dx79yfqghjaxrdrdh053nfnvkbx8p3ma7j87s7rsvy5irs963";
  };

  buildInputs = [
    libxml2
    libcanberra-gtk3
    gtk3
    mate.libmatemixer
    mate.mate-panel
    mate.mate-desktop
  ];

  nativeBuildInputs = [
    pkgconfig
    gettext
    libtool
    wrapGAppsHook
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Media tools for MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo maintainers.chpatrick ];
  };
}
