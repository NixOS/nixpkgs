{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numba
, numpy
, pytestCheckHook
, pyyaml
, rapidjson
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3cb1b0e28f420232d894d89665d5c0c8241b99e56d806171f4faf5cdfec08ae1";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ pyyaml rapidjson ];
  propagatedBuildInputs = [ numpy ];

  dontUseCmakeConfigure = true;

  checkInputs = [ pytestCheckHook numba ];
  dontUseSetuptoolsCheck = true;
  disabledTestPaths = [ "tests-cuda" ];

  meta = with lib; {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward-1.0";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
