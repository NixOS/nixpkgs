{ lib
, buildPythonPackage
, fetchPypi
, pyusb
}:

buildPythonPackage rec {
  pname = "blinkstick";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rdk3i81s6byw23za0bxvkh7sj5l16qxxgc2c53qjg3klc24wcm9";
  };

  # Upstream fix https://github.com/arvydas/blinkstick-python/pull/54
  # https://github.com/arvydas/blinkstick-python/pull/54/commits/b9bee2cd72f799f1210e5d9e13207f93bbc2d244.patch
  # has line ending issues after 1.2.0
  postPatch = ''
    substituteInPlace setup.py --replace "pyusb==1.0.0" "pyusb>=1.0.0"
  '';

  propagatedBuildInputs = [ pyusb ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "blinkstick" ];

  meta = with lib; {
    description = "Python package to control BlinkStick USB devices";
    homepage = "https://github.com/arvydas/blinkstick-python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
