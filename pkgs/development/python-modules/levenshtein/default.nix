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
  version = "0.27.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rapidfuzz";
    repo = "Levenshtein";
    tag = "v${version}";
    hash = "sha256-iKWS7gm0t3yPgeX5N09cTa3N1C6GXvIALueO8DlfLfE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython>=3.1.6,<3.2.0" Cython
  '';

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
    homepage = "https://github.com/rapidfuzz/Levenshtein";
    changelog = "https://github.com/rapidfuzz/Levenshtein/blob/v${version}/HISTORY.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
