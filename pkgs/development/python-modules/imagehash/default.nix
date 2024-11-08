{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pillow,
  pytestCheckHook,
  pythonOlder,
  pywavelets,
  scipy,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "imagehash";
  version = "4.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "JohannesBuchner";
    repo = "imagehash";
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "Python Perceptual Image Hashing Module";
    homepage = "https://github.com/JohannesBuchner/imagehash";
    changelog = "https://github.com/JohannesBuchner/imagehash/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ e1mo ];
    mainProgram = "find_similar_images.py";
  };
}
