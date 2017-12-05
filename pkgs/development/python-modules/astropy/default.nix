{ lib
, fetchPypi
, buildPythonPackage
, numpy
, pytest }:

buildPythonPackage rec {
  
  pname = "astropy";
  version = "2.0.2";

  name = "${pname}-${version}";
  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.
  src = fetchPypi {
    inherit pname version;
    sha256 = "4544a422b1173d79b2d65ba74c627f04a5fd8530d97fb604752d657d754e103d";
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


