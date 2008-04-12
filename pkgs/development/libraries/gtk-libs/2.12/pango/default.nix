args: with args;

stdenv.mkDerivation {
  name = "pango-1.20.2";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/pango/1.20/pango-1.20.2.tar.bz2;
    sha256 = "0kjqhlwm43ad8avxz4b8l4w37jjhfilv30ph8sklnqzjj5vz3ayk";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib cairo libpng];
}
