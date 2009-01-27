{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.8";

  src = fetchurl {
    url = http://www.meta-environment.org/releases/aterm-2.8.tar.gz;
    sha256 = "1vq4qpmcww3n9v7bklgp7z1yqi9gmk6hcahqjqdzc5ksa089rdms";
  };

  patches = [
    # Fix for http://bugzilla.sen.cwi.nl:8080/show_bug.cgi?id=841
    ./max-long.patch
  ];
  
  doCheck = true;

  meta = {
    homepage = http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATerm;
    license = "LGPL";
    description = "Library for manipulation of term data structures in C";
  };
}
