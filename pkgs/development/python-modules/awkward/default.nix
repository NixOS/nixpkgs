{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numba
, numpy
, pytestCheckHook
, rapidjson
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6021694adec9813842bad1987b837e439dabaf5b0dff9041201d238fca71fb4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ rapidjson ];
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
