{ absl-py
, buildPythonPackage
, dm-tree
, fetchFromGitHub
, jax
, jaxlib
, lib
, numpy
, pytestCheckHook
, toolz
}:

buildPythonPackage rec {
  pname = "chex";
  version = "0.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oIdRh0WKzdvyCfcamKRDiMsV51b6rdmNYcELjDQKGX4=";
  };

  propagatedBuildInputs = [
    absl-py
    dm-tree
    jax
    numpy
    toolz
  ];

  pythonImportsCheck = [
    "chex"
  ];

  checkInputs = [
    jaxlib
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Chex is a library of utilities for helping to write reliable JAX code.";
    homepage = "https://github.com/deepmind/chex";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
