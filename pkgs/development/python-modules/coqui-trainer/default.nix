{ lib
, buildPythonPackage
, fetchFromGitHub

, coqpit
, fsspec
, pytorch-bin

, pytestCheckHook
, soundfile
, tensorboardx
, torchvision
}:

let
  pname = "coqui-trainer";
  version = "0.0.4";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "Trainer";
    # https://github.com/coqui-ai/Trainer/issues/4
    rev = "776eba829231543d3207927fc69b321d121e527c";
    hash = "sha256-ICveftJjBNsCgegTmd/ewd/Y6XGMg7YOvchx640RFPI=";
  };

  propagatedBuildInputs = [
    coqpit
    fsspec
    pytorch-bin
    soundfile
    tensorboardx
  ];

  # tests are failing; tests require the clearml library
  # https://github.com/coqui-ai/Trainer/issues/5
  doCheck = false;

  checkInputs = [
    pytestCheckHook
    torchvision
  ];

  pythonImportsCheck = [
    "trainer"
  ];

  meta = with lib; {
    description = "A general purpose model trainer, as flexible as it gets";
    homepage = "https://github.com/coqui-ai/Trainer";
    license = licenses.asl20;
    maintainers = teams.tts.members;
  };
}
