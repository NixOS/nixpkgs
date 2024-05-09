{ lib
, buildPythonPackage
, fetchFromGitHub

# dependencies
, ftfy
, regex
, tqdm
, torch
, torchvision

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clip-anytorch";
  version = "2.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rom1504";
    repo = "CLIP";
    rev = "refs/tags/${version}";
    hash = "sha256-4A8R9aEiOWC05uhMQslhVSkQ4hyjs6VsqkFi76miodY=";
  };

  propagatedBuildInputs = [
    ftfy
    regex
    tqdm
    torch
    torchvision
  ];

  pythonImportsCheck = [
    "clip"
  ];

  # all tests require network access
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Contrastive Language-Image Pretraining";
    homepage = "https://github.com/rom1504/CLIP";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
