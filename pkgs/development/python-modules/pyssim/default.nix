{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  pillow,
  pywavelets,
  fetchpatch,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyssim";
  version = "0.7";
  pyproject = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    pillow
    pywavelets
  ];

  # PyPI tarball doesn't contain test images so let's use GitHub
  src = fetchFromGitHub {
    owner = "jterrace";
    repo = "pyssim";
    tag = "v${version}";
    sha256 = "sha256-LDNIugQeRqNsAZ5ZxS/NxHokEAwefpfRutTRpR0IcXk=";
  };

  patches = [
    # "Use PyWavelets for continuous wavelet transform"; signal.cwt was removed and broke the build
    (fetchpatch {
      url = "https://github.com/jterrace/pyssim/commit/64a58687f261eb397e9c22609b5d48497ef02762.patch?full_index=1";
      hash = "sha256-u6okuWZgGcYlf/SW0QLrAv0IYuJi7D8RHHEr8DeXKcw=";
    })
  ];

  # Tests are copied from .github/workflows/python-package.yml
  checkPhase = ''
    runHook preCheck
    $out/bin/pyssim test-images/test1-1.png test-images/test1-1.png | grep 1
    $out/bin/pyssim test-images/test1-1.png test-images/test1-2.png | grep 0.998
    $out/bin/pyssim test-images/test1-1.png "test-images/*" | grep -E " 1| 0.998| 0.672| 0.648" | wc -l | grep 4
    $out/bin/pyssim --cw --width 128 --height 128 test-images/test1-1.png test-images/test1-1.png | grep 1
    $out/bin/pyssim --cw --width 128 --height 128 test-images/test3-orig.jpg test-images/test3-rot.jpg | grep 0.938
    runHook postCheck
  '';

  meta = {
    description = "Module for computing Structured Similarity Image Metric (SSIM) in Python";
    mainProgram = "pyssim";
    homepage = "https://github.com/jterrace/pyssim";
    changelog = "https://github.com/jterrace/pyssim/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
