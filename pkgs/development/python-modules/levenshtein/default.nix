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
<<<<<<< HEAD
  version = "0.27.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rapidfuzz";
    repo = "Levenshtein";
    tag = "v${version}";
    hash = "sha256-iKWS7gm0t3yPgeX5N09cTa3N1C6GXvIALueO8DlfLfE=";
=======
  version = "0.27.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    tag = "v${version}";
    hash = "sha256-EFEyP7eqB4sUQ2ksD67kCr0BEShTiKWbk1PxXOUOGc4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "Cython>=3.1.6,<3.2.0" Cython
=======
      --replace-fail "Cython>=3.0.12,<3.1.0" Cython
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    homepage = "https://github.com/rapidfuzz/Levenshtein";
    changelog = "https://github.com/rapidfuzz/Levenshtein/blob/v${version}/HISTORY.md";
=======
    homepage = "https://github.com/maxbachmann/Levenshtein";
    changelog = "https://github.com/maxbachmann/Levenshtein/blob/v${version}/HISTORY.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
