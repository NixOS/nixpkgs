{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pillow,
  pytestCheckHook,
  pywavelets,
  scipy,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "imagehash";
  version = "4.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JohannesBuchner";
    repo = "imagehash";
    tag = "v${version}";
    hash = "sha256-/kYINT26ROlB3fIcyyR79nHKg9FsJRQsXQx0Bvl14ec=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    pillow
    pywavelets
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "imagehash" ];

  meta = {
    description = "Python Perceptual Image Hashing Module";
    homepage = "https://github.com/JohannesBuchner/imagehash";
    changelog = "https://github.com/JohannesBuchner/imagehash/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ e1mo ];
    mainProgram = "find_similar_images.py";
  };
}
