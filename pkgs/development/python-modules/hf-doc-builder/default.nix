{ lib
, buildPythonPackage
, fetchPypi
, git-python
, gql
, nbformat
, packaging
, pyyaml
, requests
, tqdm
, black
, flake8
, isort
, pytest
, pytest-xdist
, tokenizers
, torch
, transformers
}:

buildPythonPackage rec {
  pname = "hf-doc-builder";
  version = "0.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I8AnfIa9IK5lXAn8oHJzyvJT51VNFFmnKIWhhhYhVI0=";
  };

  propagatedBuildInputs = [
    git-python
    gql
    nbformat
    packaging
    pyyaml
    requests
    tqdm
  ];

  passthru.optional-dependencies = {
    all = [
      black
      flake8
      isort
      pytest
      pytest-xdist
      tokenizers
      torch
      transformers
    ];
    dev = [
      black
      flake8
      isort
      pytest
      pytest-xdist
      tokenizers
      torch
      transformers
    ];
    quality = [
      black
      flake8
      isort
    ];
    testing = [
      pytest
      pytest-xdist
      tokenizers
      torch
      transformers
    ];
    transformers = [
      transformers
    ];
  };

  pythonImportsCheck = [ "hf-doc-builder" ];

  meta = with lib; {
    description = "Doc building utility";
    homepage = "https://github.com/huggingface/doc-builder";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
