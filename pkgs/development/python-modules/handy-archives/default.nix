{
  buildPythonPackage,
  fetchPypi,
  lib,
  flit-core,
}:
buildPythonPackage rec {
  pname = "handy-archives";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "handy_archives";
    hash = "sha256-+6IRAf2eKdXjtygjJhqq4GuTUGhvDSBneG1k3Oc+s/Y=";
  };

  build-system = [ flit-core ];

  dependencies =
    [
    ];

  nativeCheckInputs = [ ];

  meta = {
    description = "Some handy archive helpers for Python.";
    homepage = "https://github.com/domdfcoding/handy-archives";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
