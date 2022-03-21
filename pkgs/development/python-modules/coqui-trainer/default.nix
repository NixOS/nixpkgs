{ lib
, buildPythonPackage
, fetchFromGitHub

, coqpit
, fsspec
, pytorch

, pytestCheckHook
, soundfile
, tensorboardx
, torchvision
}:

let
  pname = "coqui-trainer";
  version = "0.0.5";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "Trainer";
    rev = "v${version}";
    hash = "sha256-NsgCh+N2qWmRkTOjXqisVCP5aInH2zcNz6lsnIfVLiY=";
  };

  propagatedBuildInputs = [
    coqpit
    fsspec
    pytorch
    soundfile
    tensorboardx
  ];

  # only one test and that requires training data from the internet
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
