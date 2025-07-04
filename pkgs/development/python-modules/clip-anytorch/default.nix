{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  ftfy,
  packaging,
  pythonOlder,
  regex,
  setuptools,
  torch,
  torchvision,
  tqdm,
}:

buildPythonPackage rec {
  pname = "clip-anytorch";
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "rom1504";
    repo = "CLIP";
    tag = version;
    hash = "sha256-4A8R9aEiOWC05uhMQslhVSkQ4hyjs6VsqkFi76miodY=";
  };

  patches = [
    # Import packaging to be compatible with setuptools==70.0.0, https://github.com/rom1504/CLIP/pull/10
    (fetchpatch {
      name = "setuptools-comp.patch";
      url = "https://github.com/rom1504/CLIP/pull/10/commits/8137d899035d889623f6b0a0a0faae88c549dc50.patch";
      hash = "sha256-CIcuDk4QH+0g8YEa6TbKGjIcKJQqFviymVH68sKmsyk=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    ftfy
    regex
    packaging
    tqdm
    torch
    torchvision
  ];

  pythonImportsCheck = [ "clip" ];

  # All tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Contrastive Language-Image Pretraining";
    homepage = "https://github.com/rom1504/CLIP";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
