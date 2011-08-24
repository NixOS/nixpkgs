{stdenv, fetchurl, unzip, cmake, python}:

stdenv.mkDerivation {
  name = "flann-1.6.8";
  
  src = fetchurl {
    url = http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.6.8-src.zip;
    sha256 = "0ag9k821jy0983gjrfsjnqkl5axklcih0qkpfy72h3643nin0f50";
  };

  buildInputs = [ unzip cmake python ];

  meta = {
    homepage = http://people.cs.ubc.ca/~mariusm/flann/;
    license = "BSD";
    description = "Fast approximate nearest neighbor searches in high dimensional spaces";
  };
}
