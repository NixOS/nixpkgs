{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.8";

  src = fetchurl {
    url = http://homepages.cwi.nl/~daybuild/releases/aterm-2.8.tar.gz;
    sha256 = "00diz70cg4mprl4yx8lcibya0fkkskx5azyw03bhbbrnnlz9c53r";
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
