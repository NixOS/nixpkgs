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
  version = "0.27.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rapidfuzz";
    repo = "Levenshtein";
    tag = "v${finalAtts.version}";
    hash = "sha256-GPOiwbK1dV6lF3xiBCjzC3hXMWVVggvkviLHXSMU+Vs=";
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
    homepage = "https://github.com/rapidfuzz/Levenshtein";
    changelog = "https://github.com/rapidfuzz/Levenshtein/blob/v${finalAtts.version}/HISTORY.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
