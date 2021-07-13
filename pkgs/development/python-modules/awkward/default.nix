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
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25ae6114d5962c717cb87e3bc30a2f6eaa232b252cf8c51ba805b8f04664ae0d";
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
