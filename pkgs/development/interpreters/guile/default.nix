{stdenv, fetchurl, ncurses, readline}:

stdenv.mkDerivation {
  name = "guile-1.6.7";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/guile/guile-1.6.7.tar.gz;
    md5 = "c2ff2a2231f0cbb2e838dd8701a587c5";
  };

  buildInputs = [ncurses readline];
}
