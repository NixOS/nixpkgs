{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pydantic,
  transformers,
  torch,
}:

buildPythonPackage rec {
  pname = "compressed-tensors";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neuralmagic";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iTCGfufnrCT1LMz0e5MfD4XfbvYhUb/Ujbfnb5MkTUw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pydantic
    transformers
    torch
  ];
}
