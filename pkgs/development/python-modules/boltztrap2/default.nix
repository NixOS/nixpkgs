{ stdenv
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
  version = "20.2.1";
  pname = "BoltzTraP2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cbf17c5479eec82efd1e8a26202c3320b1986597a08706cafa46bfb80cc3001";
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

  meta = with stdenv.lib; {
    homepage = "http://www.boltztrap.org/";
    description = "Band-structure interpolator and transport coefficient calculator";
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };
}
