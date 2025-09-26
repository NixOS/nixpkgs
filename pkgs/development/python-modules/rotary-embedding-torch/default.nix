{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  wheel,

  # dependencies
  beartype,
  einops,
  torch,
}:

buildPythonPackage rec {
  pname = "rotary-embedding-torch";
  version = "0.8.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "rotary-embedding-torch";
    tag = version;
    hash = "sha256-mPiOtEmRtn73KGoYMum80q0iETJa9zZW9KIWL8O0dnM=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    beartype
    einops
    torch
  ];

  pythonImportsCheck = [ "rotary_embedding_torch" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Implementation of Rotary Embeddings, from the Roformer paper, in Pytorch";
    homepage = "https://github.com/lucidrains/rotary-embedding-torch";
    changelog = "https://github.com/lucidrains/rotary-embedding-torch/releases/tag/${src.tag}";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
