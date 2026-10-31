{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  latexcodec,
  pyyaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pybtex";
  version = "0.26.1";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-LlVDvqQk5g6eQu73C/9Ze+SGSdj2i6Bhp6CSskd9VGQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    latexcodec
    pyyaml
  ];

  pythonImportsCheck = [ "pybtex" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "BibTeX-compatible bibliography processor written in Python";
    homepage = "https://pybtex.org/";
    changelog = "https://bitbucket.org/pybtex-devs/pybtex/src/master/CHANGES";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
