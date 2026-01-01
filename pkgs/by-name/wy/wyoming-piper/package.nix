{
  lib,
  python3Packages,
  piper-tts,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-piper";
<<<<<<< HEAD
  version = "2.1.2";
=======
  version = "2.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-piper";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-j6QvGChAkASKdD+4XqIwC6UWdhi5oMDfYmSk6kvRrNE=";
=======
    rev = "a9bedf7947b6813807caa9eba22c745cad68e5c1";
    hash = "sha256-Ld+UZguvtVig+g4hepLnC0PEYU/yST4cpI5bLfeTVkw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "regex"
    "sentence-stream"
    "wyoming"
  ];

<<<<<<< HEAD
  dependencies =
    with python3Packages;
    [
      regex
      piper-tts
      sentence-stream
      wyoming
    ]
    ++ wyoming.optional-dependencies.zeroconf;
=======
  dependencies = with python3Packages; [
    regex
    piper-tts
    sentence-stream
    wyoming
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [
    "wyoming_piper"
  ];

  doCheck = false; # only test requires network

  nativeCheckInputs = with python3Packages; [
    numpy
    pytest-asyncio
    pytestCheckHook
    python-speech-features
  ];

  disabledTests = [
    # network access
    "test_piper"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/rhasspy/wyoming-piper/blob/${src.rev}/CHANGELOG.md";
    description = "Wyoming Server for Piper";
    mainProgram = "wyoming-piper";
    homepage = "https://github.com/rhasspy/wyoming-piper";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
