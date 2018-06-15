{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, numpy
, pytest }:

buildPythonPackage rec {
  pname = "astropy";
  version = "3.0.2";

  disabled = !isPy3k; # according to setup.py

  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.

  src = fetchPypi {
    inherit pname version;
    sha256 = "22e682904a3b8884595addfb743cf1a3ecf2b539c6616d98f8426208d822d84a";
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


