{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "libcaca-0.99.beta16";
  
  src = fetchurl {
    url = "http://caca.zoy.org/raw-attachment/wiki/libcaca/${name}.tar.gz";
    sha256 = "1k2anqc9jxvlyar6ximf9l55xzzhgwdbjbclpj64vg6lpqf96k6a";
  };
  
  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";
  
  propagatedBuildInputs = [ncurses];

  meta = {
    homepage = http://libcaca.zoy.org/;
    description = "A graphics library that outputs text instead of pixels";
    license = "WTFPL"; # http://sam.zoy.org/wtfpl/
  };
}
