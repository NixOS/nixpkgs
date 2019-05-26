{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, glibcLocales, pytest }:

buildPythonPackage rec {
  pname = "ephem";
  version = "3.7.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a4c82b1def2893e02aec0394f108d24adb17bd7b0ca6f4bc78eb7120c0212ac";
  };

  patchFlags = "-p0";
  checkInputs = [ pytest glibcLocales ];
  # JPLTest uses assets not distributed in package
  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test --pyargs ephem.tests -k "not JPLTest"
  '';

  # Unfortunately, the tests are broken for Python 3 in 3.7.6.0. They have been
  # fixed in https://github.com/brandon-rhodes/pyephem/commit/c8633854e2d251a198b0f701d0528b508baa2411
  # but there has not been a new release since then.
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "Compute positions of the planets and stars";
    homepage = https://pypi.python.org/pypi/ephem/;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ chrisrosset ];
  };
}
