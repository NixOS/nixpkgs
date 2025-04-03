{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
  stdenv,
  setuptools,
  setuptools-scm,
  torch,
  triton,
  withTransformers ? false,
  deepspeed ? null,
  accelerate ? null,
  datasets ? null,
  huggingface_hub ? null,
  pandas ? null,
  fire ? null,
  tqdm ? null,
}:

buildPythonPackage rec {
  pname = "cut-cross-entropy";
  version = "0-unstable-2024-03-10";
  pyproject = true;

  # Python 3.13 support requires PyTorch 2.6, which is not merged yet
  # https://github.com/NixOS/nixpkgs/pull/377785
  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "ml-cross-entropy";
    rev = "24fbe4b5dab9a6c250a014573613c1890190536c"; # no tags
    hash = "sha256-BVPon+T7chkpozX/IZU3KZMw1zRzlYVvF/22JWKjT2Y=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies =
    [
      torch
      triton
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      deepspeed
    ]
    ++ lib.optionals withTransformers [
      withTransformers
      accelerate
      datasets
      huggingface_hub
      pandas
      fire
      tqdm
    ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = true;

  pythonImportsCheck = [
    "cut_cross_entropy"
  ];

  meta = {
    description = "Memory-efficient cross-entropy loss implementation using Cut Cross-Entropy (CCE)";
    homepage = "https://github.com/apple/ml-cross-entropy";
    license = lib.licenses.aml;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
