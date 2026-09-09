{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-avatars";
  version = "1.4.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ibonn";
    repo = "python_avatars";
    tag = "v${version}";
    hash = "sha256-8/uhzOr0AukH0VgUhnsPNSEGJ2D5z1tqdIKzNHyHCgY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "python_avatars" ];

  meta = {
    description = "Avatar generation package for Python";
    homepage = "https://github.com/ibonn/python_avatars";
    changelog = "https://github.com/ibonn/python_avatars/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.erictapen ];
  };
}
