{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, cython_3
, rapidfuzz-capi
, scikit-build
, jarowinkler
, numpy
, hypothesis
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "2.0.8";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-LA4UpP3jFcVZTYKuq8aBvfGgEhyOLeCUsUXEgSnwb94=";
  };

  nativeBuildInputs = [
    cmake
    cython_3
    rapidfuzz-capi
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    jarowinkler
    numpy
  ];

  checkInputs = [
    hypothesis
    pandas
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm -r rapidfuzz
  '';

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
