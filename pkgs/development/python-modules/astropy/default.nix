{ lib
, fetchPypi
, buildPythonPackage
, numpy
, cython
, h5py
, scipy }:

buildPythonPackage rec {
  
  pname = "astropy";
  version = "2.0.1";

  name = "${pname}-${version}";
  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.
  src = fetchPypi {
    inherit pname version;
    sha256 = "25e0881a392a2e03b4a705cf9592f01894d23f64797323b21387efa8ea9ec03e";
  };
  propagatedBuildInputs = [ numpy cython h5py scipy ];


  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = http://www.astropy.org;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames ];
  };
}


