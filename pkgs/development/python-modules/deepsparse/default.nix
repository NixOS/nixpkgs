{ lib
, buildPythonPackage
# , fetchFromGitHub
, fetchPypi
, pythonRelaxDepsHook
, setuptools
, wheel
, click
, onnx
, numpy
, pydantic_1
, requests
, sparsezoo
, tqdm
, protobuf
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deepsparse";
  version = "1.6.1";
  pyproject = true;

  # src = fetchFromGitHub {
  #   owner = "neuralmagic";
  #   repo = "deepsparse";
  #   rev = "refs/tags/v${version}";
  #   hash = "sha256-DqT+8FpppoKQ5wcEh0oaUYDc1VEbURK46GlIknh7KLc=";
  # };
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k+SLrdEeYv7nO7Ci3Q0GiPnWgpRN4LgTXBc03CbxJKg=";
  };

  pythonRelaxDeps = [
    "onnx"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    click
    numpy
    onnx
    pydantic_1
    sparsezoo
    requests
    tqdm
    protobuf
  ];

  pythonImportsCheck = [ "deepsparse" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Sparsity-aware deep learning inference runtime for CPUs";
    homepage = "https://github.com/neuralmagic/deepsparse";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
