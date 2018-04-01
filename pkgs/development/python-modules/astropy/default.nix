{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, numpy
, pytest }:

buildPythonPackage rec {
  pname = "astropy";
  version = "3.0";

  disabled = !isPy3k; # according to setup.py

  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e0ad19b9d6d227bdf0932bbe64a8c5dd4a47d4ec078586cf24bf9f0c61d9ecf";
  };

  propagatedBuildInputs = [ pytest numpy ]; # yes it really has pytest in install_requires

  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = http://www.astropy.org;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames ];
  };
}


