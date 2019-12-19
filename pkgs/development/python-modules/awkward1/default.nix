{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numba
, numpy
, pytest
, rapidjson
}:

buildPythonPackage rec {
  pname = "awkward1";
  version = "0.1.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b3c8ef1382074807d67a0d0051a3a611452f4423b1d128a483eb5d2b0d1b347";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ rapidjson ];
  propagatedBuildInputs = [ numpy ];

  dontUseCmakeConfigure = true;

  checkInputs = [ pytest numba ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Development of awkward 1.0, to replace scikit-hep/awkward-array in 2020";
    homepage = "https://github.com/scikit-hep/awkward-1.0";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
