{ stdenv, fetchurl, pkgconfig, glib, libsigcxx }:

stdenv.mkDerivation rec {
  name = "glibmm-2.18.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/2.18/${name}.tar.bz2";
    sha256 = "0jg65hv6pwxqk4fabsjjz2zwn5hb6rgy3szj956avliarbliyr3r";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [glib libsigcxx];

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = "LGPLv2+";
  };
}
