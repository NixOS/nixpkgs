{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, pythonAtLeast

, coqpit
, fsspec
, pytorch-bin
, tensorboardx
, protobuf

, pytestCheckHook
, soundfile
, torchvision-bin
}:

let
  pname = "coqui-trainer";
  version = "0.0.14";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "Trainer";
    rev = "refs/tags/v${version}";
    hash = "sha256-WvJDGV7gmf/QQN3SswTq/ABy9ppPFi5xYnMeL/M7GxY=";
  };

  propagatedBuildInputs = [
    coqpit
    fsspec
    pytorch-bin
    soundfile
    tensorboardx
    protobuf
  ];

  # only one test and that requires training data from the internet
  doCheck = false;

  checkInputs = [
    pytestCheckHook
    torchvision-bin
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
