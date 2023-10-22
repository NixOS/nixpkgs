{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, wheel

# dependencies
, einops
, torch
}:

buildPythonPackage rec {
  pname = "rotary-embedding-torch";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "rotary-embedding-torch";
    rev = version;
    hash = "sha256-uTOKdxqbSLRJl0gnz3TvpVwhrfqflAp0wfn6d13+YrM=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    einops
    torch
  ];

  pythonImportsCheck = [
    "rotary_embedding_torch"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Implementation of Rotary Embeddings, from the Roformer paper, in Pytorch";
    homepage = "https://github.com/lucidrains/rotary-embedding-torch";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
