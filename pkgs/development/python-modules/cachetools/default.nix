{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cachetools";
<<<<<<< HEAD
  version = "6.2.2";
  pyproject = true;

=======
  version = "6.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "tkem";
    repo = "cachetools";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-seoyqkrRQpRiMd5GTEvenjirn173Hq40Zuk1u7TvMPI=";
=======
    hash = "sha256-o3Ice6w7Ovot+nsmTpsl/toosZuVbi9RvRGs07W4H0Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cachetools" ];

<<<<<<< HEAD
  meta = {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    changelog = "https://github.com/tkem/cachetools/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    changelog = "https://github.com/tkem/cachetools/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
