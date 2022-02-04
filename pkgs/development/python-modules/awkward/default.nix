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
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4e642dfe496d2acb245c90e37dc18028e25d5e936421e7371ea6ba0fde6435a";
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
