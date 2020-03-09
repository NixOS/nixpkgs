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
  version = "19.11.1";
  pname = "BoltzTraP2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3927ae782b7329dede2bf85ff5ff328c88f0514ecb592267e28912340f395d3e";
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
