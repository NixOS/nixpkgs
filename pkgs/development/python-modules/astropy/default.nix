{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, numpy
, pytest }:

buildPythonPackage rec {
  pname = "astropy";
  version = "3.0.1";

  disabled = !isPy3k; # according to setup.py

  doCheck = false; #Some tests are failing. More importantly setup.py hangs on completion. Needs fixing with a proper shellhook.

  src = fetchPypi {
    inherit pname version;
    sha256 = "c35f4433c14ddfcaf2407cc815385f3d85396727e9a1e660cf66a7c4f5dd1067";
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


