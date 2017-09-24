{ lib, buildPythonPackage, python, fetchPypi }:

buildPythonPackage rec {
  pname = "ephem";
  name = "${pname}-${version}";
  version = "3.7.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a4c82b1def2893e02aec0394f108d24adb17bd7b0ca6f4bc78eb7120c0212ac";
  };

  # Unfortunately, the tests are broken for Python 3 in 3.7.6.0. They have been
  # fixed in https://github.com/brandon-rhodes/pyephem/commit/c8633854e2d251a198b0f701d0528b508baa2411
  # but there has not been a new release since then.
  doCheck = false;

  meta = with lib; {
    description = "Compute positions of the planets and stars";
    homepage = https://pypi.python.org/pypi/ephem/;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ chrisrosset ];
  };
}
