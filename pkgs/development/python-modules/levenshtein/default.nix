{
  lib,
  buildPythonPackage,
  cmake,
  cython,
  fetchFromGitHub,
  ninja,
  pytestCheckHook,
  pythonOlder,
  rapidfuzz,
  rapidfuzz-cpp,
  scikit-build-core,
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.26.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "refs/tags/v${version}";
    hash = "sha256-uLOOAmJ8Y0z+tuIIOSnI8qZoZ+IA2+tNBX1lDCvc8+A=";
    fetchSubmodules = true; # # for vendored `rapidfuzz-cpp`
  };

  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [ rapidfuzz-cpp ];

  dependencies = [ rapidfuzz ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "Levenshtein" ];

  meta = with lib; {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage = "https://github.com/maxbachmann/Levenshtein";
    changelog = "https://github.com/maxbachmann/Levenshtein/blob/${src.rev}/HISTORY.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
