{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, cython
, rapidfuzz-capi
, scikit-build
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jarowinkler";
  version = "1.0.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "JaroWinkler";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-zVAcV6xxqyfXRUcyWo9PcOdagcexJc/D5k4g5ag3hbY=";
  };

  nativeBuildInputs = [
    cmake
    cython
    rapidfuzz-capi
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm -r jarowinkler
  '';

  pythonImportsCheck = [ "jarowinkler" ];

  meta = with lib; {
    description = "Library for fast approximate string matching using Jaro and Jaro-Winkler similarity";
    homepage = "https://github.com/maxbachmann/JaroWinkler";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
