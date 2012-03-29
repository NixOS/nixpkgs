{ stdenv, fetchurl, pkgconfig, glib, libsigcxx }:

stdenv.mkDerivation rec {
  name = "glibmm-2.30.1";

  src = fetchurl {
    url = mirror://gnome/sources/glibmm/2.30/glibmm-2.30.1.tar.xz;
    sha256 = "15zqgx6rashyhxk89qjqq05p6m40akpgzyjk8bfb3jk68rc2nn39";
  };

  buildNativeInputs = [pkgconfig];
  propagatedBuildInputs = [glib libsigcxx];

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
