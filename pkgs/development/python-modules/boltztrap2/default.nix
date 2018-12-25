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
  version = "18.9.1";
  pname = "BoltzTraP2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b828ad2b3b3a40956ef866e462e4c82faf83be79348af3945d4e7cede8a53913";
  };

  buildInputs = [ cython cmake ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ spglib numpy scipy matplotlib ase netcdf4 ];

  # pypi release does no include files for tests
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://www.boltztrap.org/;
    description = "Band-structure interpolator and transport coefficient calculator";
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };
}
