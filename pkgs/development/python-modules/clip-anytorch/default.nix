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
  version = "2.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rom1504";
    repo = "CLIP";
    rev = version;
    hash = "sha256-EqVkpMQHawoCFHNupf49NrvLdGCq35wnYBpdP81Ztd4=";
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
