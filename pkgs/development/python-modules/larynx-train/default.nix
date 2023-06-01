{ lib
, buildPythonPackage
, larynx

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

buildPythonPackage rec {
  inherit (larynx) version src meta;

  pname = "larynx-train";
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
    make -C larynx_train/vits/monotonic_align
  '';

  postInstall = ''
    export MONOTONIC_ALIGN=$out/${python.sitePackages}/larynx_train/vits/monotonic_align/monotonic_align
    mkdir -p $MONOTONIC_ALIGN
    cp -v ./larynx_train/vits/monotonic_align/larynx_train/vits/monotonic_align/core.*.so $MONOTONIC_ALIGN/
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
    "larynx_train"
  ];

  doCheck = false; # no tests
}
