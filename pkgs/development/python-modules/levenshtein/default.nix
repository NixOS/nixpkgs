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
    hash = "sha256-EFEyP7eqB4sUQ2ksD67kCr0BEShTiKWbk1PxXOUOGc4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython>=3.0.12,<3.1.0" Cython
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
    homepage = "https://github.com/maxbachmann/Levenshtein";
    changelog = "https://github.com/maxbachmann/Levenshtein/blob/v${version}/HISTORY.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
