{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "cantarell-fonts-0.0.7";

  src = fetchurl {
    url = mirror://gnome/sources/cantarell-fonts/0.0/cantarell-fonts-0.0.7.tar.xz;
    sha256 = "1410ywvi951ngmx58g339phzsaf1rgjja6i0xvg49r4ds90zh8ba";
  };

  meta = {
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
