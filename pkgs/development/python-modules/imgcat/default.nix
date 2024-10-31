{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pillow,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tensorflow,
  torch,
  torchvision,
}:

buildPythonPackage rec {
  pname = "imgcat";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wookayin";
    repo = "python-imgcat";
    rev = "refs/tags/v${version}";
    hash = "sha256-LFXfCMWMdOjFYhXba9PCCIYnqR7gTRG63NAoC/nD2wk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner<5.0'" ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    matplotlib
    numpy
    pillow
    pytestCheckHook
    tensorflow
    torch
    torchvision
  ];

  pythonImportsCheck = [ "imgcat" ];

  meta = with lib; {
    description = "Imgcat in Python";
    homepage = "https://github.com/wookayin/python-imgcat";
    changelog = "https://github.com/wookayin/python-imgcat/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
