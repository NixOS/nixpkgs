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
  version = "0.1.38";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c87defa8c1661ffe36f8a785fa9a60ae3b70484984a935e710cd8cb1f763fd7";
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
