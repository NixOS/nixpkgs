{ lib
, fetchPypi
, buildPythonPackage
, numpy
, pytest }:

buildPythonPackage rec {
  
  pname = "astropy";
  version = "2.0.3";

  name = "${pname}-${version}";
  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.
  src = fetchPypi {
    inherit pname version;
    sha256 = "fdfc0248f6250798ed6d1327be609cb901db89ae01fc768cfbc9e263bdf56f4f";
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


