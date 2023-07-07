{ buildPythonPackage
, piper-tts

# build
, cython
, python

# propagates
, espeak-phonemizer
, librosa
, numpy
, onnxruntime
, pytorch-lightning
, torch
}:

buildPythonPackage {
  inherit (piper-tts) version src meta;

  pname = "piper-train";
  format = "setuptools";

  sourceRoot = "source/src/python";

  nativeBuildInputs = [
    cython
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "onnxruntime~=1.11.0" "onnxruntime" \
      --replace "pytorch-lightning~=1.7.0" "pytorch-lightning" \
      --replace "torch~=1.11.0" "torch"
  '';

  postBuild = ''
    make -C piper_train/vits/monotonic_align
  '';

  postInstall = ''
    export MONOTONIC_ALIGN=$out/${python.sitePackages}/piper_train/vits/monotonic_align/monotonic_align
    mkdir -p $MONOTONIC_ALIGN
    cp -v ./piper_train/vits/monotonic_align/piper_train/vits/monotonic_align/core.*.so $MONOTONIC_ALIGN/
  '';

  propagatedBuildInputs = [
    espeak-phonemizer
    librosa
    numpy
    onnxruntime
    pytorch-lightning
    torch
  ];

  pythonImportsCheck = [
    "piper_train"
  ];

  doCheck = false; # no tests
}
