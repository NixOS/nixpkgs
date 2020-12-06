{ stdenv, fetchFromGitHub, fetchpatch, unzip, cmake, python }:

stdenv.mkDerivation {
  name = "flann-1.9.1";

  src = fetchFromGitHub {
    owner = "mariusmuja";
    repo = "flann";
    rev = "1.9.1";
    sha256 = "13lg9nazj5s9a41j61vbijy04v6839i67lqd925xmxsbybf36gjc";
  };

  patches = [
    # Upstream issue: https://github.com/mariusmuja/flann/issues/369
    (fetchpatch {
      url = "https://raw.githubusercontent.com/buildroot/buildroot/45a39b3e2ba42b72d19bfcef30db1b8da9ead51a/package/flann/0001-src-cpp-fix-cmake-3.11-build.patch";
      sha256 = "1gmj06cmnqvwxx649mxaivd35727wj6w7710zbcmmgmsnyfh2js4";
    })
  ];

  buildInputs = [ unzip cmake python ];

  meta = {
    homepage = "http://people.cs.ubc.ca/~mariusm/flann/";
    license = stdenv.lib.licenses.bsd3;
    description = "Fast approximate nearest neighbor searches in high dimensional spaces";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
