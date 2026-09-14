{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  pytestCheckHook,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "fastcluster";
  version = "1.3.0";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-1SM666XD+qlJx/pqOTRaCfcWzOu9dIVB5XNchmaW3wI=";
  };

  pyproject = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  meta = {
    description = "Fast hierarchical clustering routines for Python";
    homepage = "https://danifold.net/fastcluster.html";
    downloadPage = "https://pypi.org/project/fastcluster/";
    changelog = "https://github.com/fastcluster/fastcluster/blob/v${version}/NEWS.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ erooke ];
  };
}
