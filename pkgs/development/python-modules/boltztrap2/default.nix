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
  version = "22.3.2";
  pname = "BoltzTraP2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Yo37xdXxCQKkA+lrFEZp1DxjJy216Q6aYYT68PEx9JU=";
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
