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
  version = "0.1.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2269aca04c827549435e24f9976d27e904d02b74a30caa9a2a463225a8ba1609";
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
