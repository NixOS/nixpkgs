{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gentools";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "gentools";
    tag = "v${version}";
    hash = "sha256-+6KTFxOpwvGOCqy6JU87gOZmDa6MvjR10qES5wIfrjI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gentools" ];

<<<<<<< HEAD
  meta = {
    description = "Tools for generators, generator functions, and generator-based coroutines";
    homepage = "https://gentools.readthedocs.io/";
    changelog = "https://github.com/ariebovenberg/gentools/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Tools for generators, generator functions, and generator-based coroutines";
    homepage = "https://gentools.readthedocs.io/";
    changelog = "https://github.com/ariebovenberg/gentools/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
