{ lib
, fetchPypi
, buildPythonPackage
, numpy
, cython
, h5py
, scipy }:

buildPythonPackage rec {
  
  pname = "astropy";
  version = "1.3.3";

  name = "${pname}-${version}";
  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.
  src = fetchPypi {
    inherit pname version;
    sha256 = "ed093e033fcbee5a3ec122420c3376f8a80f74663214560727d3defe82170a99";
  };
  propagatedBuildInputs = [ numpy cython h5py scipy ];


  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = "http://www.astropy.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames ];
  };
}


