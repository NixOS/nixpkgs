{ lib, buildPythonPackage, fetchPypi, fetchpatch, pyusb }:

buildPythonPackage rec {
  pname = "BlinkStick";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3edf4b83a3fa1a7bd953b452b76542d54285ff6f1145b6e19f9b5438120fa408";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/arvydas/blinkstick-python/commit/a9227d0.patch";
      sha256 = "1mcmxlnkbfxwp84qz32l5rlc7r9anh9yhnqaj1y8rny5s13jb01f";
    })
    (fetchpatch {
      url = "https://github.com/arvydas/blinkstick-python/pull/54.patch";
      sha256 = "1gjq6xbai794bbdyrv82i96l1a7qkwvlhzd6sa937dy5ivv6s6hl";
    })
  ];

  propagatedBuildInputs = [ pyusb ];

  meta = with lib; {
    description = "Python package to control BlinkStick USB devices";
    homepage = "https://pypi.python.org/pypi/BlinkStick/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
