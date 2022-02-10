{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, cython
, scikit-build
, python
, numpy
, hypothesis
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "2.0.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-4gUh1GM5u1LuHAkMLz2iEpZDQvviAXenDbiOBE6cgjU=";
  };

  nativeBuildInputs = [
    cmake
    cython
    scikit-build
  ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${scikit-build}/${python.sitePackages}/skbuild/resources/cmake"
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    hypothesis
    pandas
    pytestCheckHook
  ];

  disabledTests = [
    "test_levenshtein_block" # hypothesis data generation too slow
  ];

  pythonImportsCheck = [
    "rapidfuzz.fuzz"
    "rapidfuzz.string_metric"
    "rapidfuzz.process"
    "rapidfuzz.utils"
  ];

  meta = with lib; {
    description = "Rapid fuzzy string matching";
    homepage = "https://github.com/maxbachmann/RapidFuzz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
