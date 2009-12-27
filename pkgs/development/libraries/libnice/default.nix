{stdenv, fetchurl, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "libnice-0.0.10";
  
  src = fetchurl {
    url = http://nice.freedesktop.org/releases/libnice-0.0.10.tar.gz;
    sha256 = "04r7syk67ihw8gzy83f603kmwvqv2dpd1mrfzpk4p72vjqrqidl6";
  };

  buildInputs = [ pkgconfig glib ];

  meta = {
    homepage = http://nice.freedesktop.org/wiki/;
  };
}
