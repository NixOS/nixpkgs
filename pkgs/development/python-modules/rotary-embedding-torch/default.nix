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
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "rotary-embedding-torch";
    rev = version;
    hash = "sha256-dST3eJnOcG2s9tiD/Fb9BvLS6nIpE8RXly92PK/gCC8=";
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
