{stdenv, fetchurl, unzip, cmake, python}:

stdenv.mkDerivation {
  name = "flann-1.8.4";
  
  src = fetchurl {
    url = http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.8.4-src.zip;
    sha256 = "022w8hph7bli5zbpnk3z1qh1c2sl5hm8fw2ccim651ynn0hr7fyz";
  };

  buildInputs = [ unzip cmake python ];

  meta = {
    homepage = http://people.cs.ubc.ca/~mariusm/flann/;
    license = stdenv.lib.licenses.bsd3;
    description = "Fast approximate nearest neighbor searches in high dimensional spaces";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
