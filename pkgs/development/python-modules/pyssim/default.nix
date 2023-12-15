{ lib, buildPythonPackage, fetchFromGitHub, numpy, scipy, pillow, fetchpatch }:

buildPythonPackage rec {
  pname = "pyssim";
  version = "0.6";
  format = "setuptools";

  propagatedBuildInputs = [ numpy scipy pillow ];

  # PyPI tarball doesn't contain test images so let's use GitHub
  src = fetchFromGitHub {
    owner = "jterrace";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VvxQTvDTDms6Ccyclbf9P0HEQksl5atPPzHuH8yXTmc=";
  };

  patches = [
    # "Replace Image.ANTIALIAS with Image.LANCZOS"
    # Image.ANTIALIAS has been removed in Pillow 10.0.0,
    # the version currently in nixpkgs,
    # and Image.LANCZOS is a drop-in since Pillow 2.7.0.
    # https://github.com/jterrace/pyssim/pull/45
    (fetchpatch {
      url = "https://github.com/jterrace/pyssim/commit/db4296c12ca9c027eb9cd61b52195a78dfcc6711.patch";
      hash = "sha256-wNp47EFtjXv6jIFX25IErXg83ksmGRNFKNeMFS+tP6s=";
    })
  ];

  # Tests are copied from .travis.yml
  checkPhase = ''
    $out/bin/pyssim test-images/test1-1.png test-images/test1-1.png | grep 1
    $out/bin/pyssim test-images/test1-1.png test-images/test1-2.png | grep 0.998
    $out/bin/pyssim test-images/test1-1.png "test-images/*" | grep -E " 1| 0.998| 0.672| 0.648" | wc -l | grep 4
    $out/bin/pyssim --cw --width 128 --height 128 test-images/test1-1.png test-images/test1-1.png | grep 1
    $out/bin/pyssim --cw --width 128 --height 128 test-images/test3-orig.jpg test-images/test3-rot.jpg | grep 0.938
  '';

  meta = with lib; {
    description = "Module for computing Structured Similarity Image Metric (SSIM) in Python";
    homepage = "https://github.com/jterrace/pyssim";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
