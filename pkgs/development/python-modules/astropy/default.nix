{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, numpy
, pytest }:

buildPythonPackage rec {
  pname = "astropy";
  version = "3.1";

  disabled = !isPy3k; # according to setup.py

  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ldmdwfp0g8293k4gyp962nv7ik4zw83p1khkq8jqkzmk7qf040y";
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


