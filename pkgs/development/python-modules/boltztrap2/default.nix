{ lib
, buildPythonPackage
, fetchPypi
, spglib
, numpy
, scipy
, matplotlib
, ase
, netcdf4
, pytest
, pythonOlder
, cython
, cmake
}:

buildPythonPackage rec {
  version = "20.7.1";
  pname = "BoltzTraP2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41caa32e5778323471d87033f23537f6178a7aea64fba894c7f2b2579b51f7ed";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ cmake cython ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ spglib numpy scipy matplotlib ase netcdf4 ];

  # pypi release does no include files for tests
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "http://www.boltztrap.org/";
    description = "Band-structure interpolator and transport coefficient calculator";
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };
}
