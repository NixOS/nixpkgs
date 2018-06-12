{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, numpy
, pytest }:

buildPythonPackage rec {
  pname = "astropy";
  version = "3.0.3";

  disabled = !isPy3k; # according to setup.py

  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.

  src = fetchPypi {
    inherit pname version;
    sha256 = "6af07abe5e263820a3dec93832a6ad74005013071490e125afbc6514411721da";
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


