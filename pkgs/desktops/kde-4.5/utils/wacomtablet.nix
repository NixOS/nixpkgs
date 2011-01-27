{ stdenv, fetchurl, automoc4, cmake, kdelibs, qt4 }:

stdenv.mkDerivation rec {
  name = "wacomtablet";
  version = "1.2.5";

  src = fetchurl {
    url = "http://kde-apps.org/CONTENT/content-files/114856-${name}-${version}.tar.gz";
    sha256 = "11hfab6sqmhvd0m1grc9m9yfi0p7rk0bycj9wqgkgbc8cwgps6sf";
  };

  buildInputs = [ automoc4 cmake kdelibs qt4 ];

  meta = with stdenv.lib; {
    description = "KDE Wacom graphic tablet configuration tool";
    license = "GPLv2";
    homepage = http://kde-apps.org/content/show.php/wacom+tablet?content=114856;
    platforms = platforms.linux;
  };
}
