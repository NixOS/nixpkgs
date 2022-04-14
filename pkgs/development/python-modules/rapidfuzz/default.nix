{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, cython
, scikit-build
, python
, numpy
, rapidfuzz-capi
, hypothesis
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "2.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-LA4UpP3jFcVZTYKuq8aBvfGgEhyOLeCUsUXEgSnwb94=";
  };

  nativeBuildInputs = [
    cmake
    cython
    scikit-build
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "==" ">=" \
      --replace "Cython==3.0.0a10" "Cython>=0.29.0" \
      --replace "scikit-build>=0.13.0" "scikit-build>=0.12.0"
  '';

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${scikit-build}/${python.sitePackages}/skbuild/resources/cmake"
  ];

  propagatedBuildInputs = [
    numpy
    rapidfuzz-capi
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
