args: with args;

stdenv.mkDerivation rec {
  name = "glibmm-2.22.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/2.22/${name}.tar.bz2";
    sha256 = "1h5nxhh6xr1m3jn6bawl3vq5i285k3kdpzqa65zxmxydzm5gy1gi";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [glib libsigcxx];

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = "LGPLv2+";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
