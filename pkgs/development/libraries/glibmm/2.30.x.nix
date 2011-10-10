{ stdenv, fetchurl_gnome, pkgconfig, glib, libsigcxx, xz }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "glibmm";
    major = "2"; minor = "30"; patchlevel = "0"; extension = "xz";
    sha256 = "1d0dxq4iamch8igrnbvbfwkfpvcnjfzyr9iq2x8hi89b9k1kzbd7";
  };

  buildNativeInputs = [pkgconfig xz];
  propagatedBuildInputs = [glib libsigcxx];

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
