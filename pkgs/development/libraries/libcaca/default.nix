{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "libcaca-0.99.beta18";
  
  src = fetchurl {
    url = "http://caca.zoy.org/files/libcaca/${name}.tar.gz";
    sha256 = "189kdh7zi88gxb3w33rh0p5l0yhn7s1c2xjgrpf24q2a7xihdskp";
  };
  
  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";
  
  propagatedBuildInputs = [ncurses];

  meta = {
    homepage = http://libcaca.zoy.org/;
    description = "A graphics library that outputs text instead of pixels";
    license = "WTFPL"; # http://sam.zoy.org/wtfpl/
  };
}
