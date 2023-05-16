{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "orderedset";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0abf19w37kxypsj6v7dz79jj92y1kivjk2zivnrv7rw6bbxwrxdj";
  };

  meta = with lib; {
    description = "An Ordered Set implementation in Cython";
    homepage = "https://pypi.python.org/pypi/orderedset";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.jtojnar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # No support for Python 3.9/3.10
    # https://github.com/simonpercivall/orderedset/issues/36
    broken = true;
  };
}
