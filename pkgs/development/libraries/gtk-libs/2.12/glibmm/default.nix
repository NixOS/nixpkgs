args: with args;

stdenv.mkDerivation {
  name = "glibmm-2.12.10";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.12/glibmm-2.12.10.tar.bz2;
    sha256 = "02rjjdh0f6kafa1sn4y5ykvm4f2qn3yh4kr4lngcv7vzasqn1dr1";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [glib libsigcxx];
}

