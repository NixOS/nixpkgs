{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.7";

  src = fetchurl {
    url = http://homepages.cwi.nl/~daybuild/releases//aterm-2.7.tar.gz;
    sha256 = "0zhs0rncn4iankr70kbms64dwxm9i0956gs02dbw7ylx4mln8ynn";
  };

  #doCheck = true;

  CFLAGS = "-O0";

  meta = {
    homepage = http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATerm;
    license = "LGPL";
    description = "Library for manipulation of term data structures in C";
  };
}
