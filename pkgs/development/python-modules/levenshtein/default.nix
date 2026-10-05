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

buildPythonPackage (finalAtts: {
  pname = "levenshtein";
  version = "0.27.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rapidfuzz";
    repo = "Levenshtein";
    tag = "v${finalAtts.version}";
    hash = "sha256-W21aC2/dJ7IoK9SnGSqXsJx9/1lF4ymnPGOdMU+T7O4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython>=3.1.6,<3.3.0" "Cython"
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
    changelog = "https://github.com/rapidfuzz/Levenshtein/blob/v${finalAtts.version}/HISTORY.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
