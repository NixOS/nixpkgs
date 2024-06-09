{
  buildPythonPackage,
  fetchPypi,
  lib,

  # propagates
  click,
  dlib,
  face-recognition-models,
  numpy,
  pillow,

  # tests
  pytestCheckHook,
  config,
  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage rec {
  pname = "face-recognition";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "face_recognition";
    inherit version;
    hash = "sha256-Xl790WhqpWavDTzBMTsTHksZdleo/9A2aebT+tknBew=";
  };

  propagatedBuildInputs = [
    click
    dlib
    face-recognition-models
    numpy
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Disables tests when running with cuda due to https://github.com/NixOS/nixpkgs/issues/225912
  doCheck = !config.cudaSupport;

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/ageitgey/face_recognition";
    maintainers = with maintainers; [ ];
    description = "The world's simplest facial recognition api for Python and the command line";
  };
}
