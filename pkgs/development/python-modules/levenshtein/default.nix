{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  cython,
  ninja,
  scikit-build-core,
  rapidfuzz-cpp,
  rapidfuzz,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.27.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    tag = "v${version}";
    hash = "sha256-YMXT0rfd7S4jisMdHqOrsHKLzQ2hm8UfxhIFU7BbWBQ=";
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

  meta = {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage = "https://github.com/maxbachmann/Levenshtein";
    changelog = "https://github.com/maxbachmann/Levenshtein/blob/v${version}/HISTORY.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
