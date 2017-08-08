{stdenv, fetchFromGitHub, unzip, cmake, python}:

stdenv.mkDerivation {
  name = "flann-1.9.1";

  src = fetchFromGitHub {
    owner = "mariusmuja";
    repo = "flann";
    rev = "1.9.1";
    sha256 = "13lg9nazj5s9a41j61vbijy04v6839i67lqd925xmxsbybf36gjc";
  };

  buildInputs = [ unzip cmake python ];

  meta = {
    homepage = http://people.cs.ubc.ca/~mariusm/flann/;
    license = stdenv.lib.licenses.bsd3;
    description = "Fast approximate nearest neighbor searches in high dimensional spaces";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
