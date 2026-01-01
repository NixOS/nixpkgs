{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-metadata,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "chameleon";
  version = "4.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "malthe";
    repo = "chameleon";
    tag = version;
    hash = "sha256-zCEM5yl8Y11FbexD7veS9bFJgm30L6fsTde59m2t1ec=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "chameleon" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/malthe/chameleon/blob/${src.tag}/CHANGES.rst";
    description = "Fast HTML/XML Template Compiler";
    downloadPage = "https://github.com/malthe/chameleon";
    homepage = "https://chameleon.readthedocs.io";
<<<<<<< HEAD
    license = lib.licenses.bsd0;
=======
    license = licenses.bsd0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
