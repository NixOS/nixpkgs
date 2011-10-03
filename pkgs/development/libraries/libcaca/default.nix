{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "libcaca-0.99.beta17";
  
  src = fetchurl {
    url = "http://caca.zoy.org/files/libcaca/${name}.tar.gz";
    sha256 = "1mpicj3xf4d0mf8papb1zbks5yzi4lnj6yh5cvpq7sb176gawmb3";
  };
  
  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";
  
  propagatedBuildInputs = [ncurses];

  meta = {
    homepage = http://libcaca.zoy.org/;
    description = "A graphics library that outputs text instead of pixels";
    license = "WTFPL"; # http://sam.zoy.org/wtfpl/
  };
}
