{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  setuptools,
  setuptools-scm,
  torch,
  triton,
  transformers ? null,
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

  src = fetchFromGitHub {
    owner = "apple";
    repo = "ml-cross-entropy";
    rev = "24fbe4b5dab9a6c250a014573613c1890190536c"; # no tags
    sha256 = "sha256-BVPon+T7chkpozX/IZU3KZMw1zRzlYVvF/22JWKjT2Y=";
  };

  build-system = [ setuptools ];
  nativeBuildInputs = [ setuptools-scm ];

  dependencies =
    [
      torch
      triton
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      deepspeed
    ]
    ++ lib.optionals (transformers != null) [
      transformers
      accelerate
      datasets
      huggingface_hub
      pandas
      fire
      tqdm
    ];

  doCheck = true;

  pythonImportsCheck = [
    "cut_cross_entropy"
  ];

  meta = with lib; {
    description = "Memory-efficient cross-entropy loss implementation using Cut Cross-Entropy (CCE)";
    homepage = "https://github.com/apple/ml-cross-entropy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
