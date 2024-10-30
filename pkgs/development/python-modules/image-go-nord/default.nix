{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg-python,
  numpy,
  pillow,
  pypaInstallHook,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptoolsBuildHook,
}:

buildPythonPackage rec {
  pname = "image-go-nord";
  version = "1.1.0";
  pyproject = false;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Schrodinger-Hat";
    repo = "ImageGoNord-pip";
    rev = "refs/tags/v${version}";
    hash = "sha256-2Dnl0dcdMo4PnhHTb/5cJ7C0CvW84av4CCbrTLPqopg=";
  };

  nativeBuildInputs = [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  dependencies = [
    ffmpeg-python
    numpy
    pillow
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ImageGoNord" ];

  meta = {
    description = "Tool that can convert rgb images to nordtheme palette";
    homepage = "https://github.com/Schrodinger-Hat/ImageGoNord-pip";
    changelog = "https://github.com/Schroedinger-Hat/ImageGoNord-pip/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
