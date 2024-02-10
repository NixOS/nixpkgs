{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "orderedset";
  version = "2.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0abf19w37kxypsj6v7dz79jj92y1kivjk2zivnrv7rw6bbxwrxdj";
  };

  meta = with lib; {
    description = "An Ordered Set implementation in Cython";
    homepage = "https://pypi.python.org/pypi/orderedset";
    license = licenses.bsd3;
    maintainers = [ ];
    # No support for Python 3.9/3.10
    # https://github.com/simonpercivall/orderedset/issues/36
    broken = true;
  };
}
