{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, scipy, pillow }:

buildPythonPackage rec {
  pname = "pyssim";
  version = "0.4";

  propagatedBuildInputs = [ numpy scipy pillow ];

  # PyPI tarball doesn't contain test images so let's use GitHub
  src = fetchFromGitHub {
    owner = "jterrace";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rnj3xdhma1fc0fg0jjsdy74ar0hgr3w8kygbnijqjdms7m3asqm";
  };

  # Tests are copied from .travis.yml
  checkPhase = ''
    $out/bin/pyssim test-images/test1-1.png test-images/test1-1.png | grep 1
    $out/bin/pyssim test-images/test1-1.png test-images/test1-2.png | grep 0.998
    $out/bin/pyssim test-images/test1-1.png "test-images/*" | grep -E " 1| 0.998| 0.672| 0.648" | wc -l | grep 4
    $out/bin/pyssim --cw --width 128 --height 128 test-images/test1-1.png test-images/test1-1.png | grep 1
    $out/bin/pyssim --cw --width 128 --height 128 test-images/test3-orig.jpg test-images/test3-rot.jpg | grep 0.938
  '';

  meta = with stdenv.lib; {
    description = "Module for computing Structured Similarity Image Metric (SSIM) in Python";
    homepage = https://github.com/jterrace/pyssim;
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
