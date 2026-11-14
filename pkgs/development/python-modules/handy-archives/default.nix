{
  buildPythonPackage,
  fetchPypi,
  lib,
  flit-core,
}:
buildPythonPackage rec {
  pname = "handy-archives";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "handy_archives";
    hash = "sha256-Ko0SXNnEJDO5eDhINPSh3xhKnjuraL9EDfGEttrhL/M=";
  };

  build-system = [ flit-core ];

  dependencies = [
  ];

  meta = {
    description = "Some handy archive helpers for Python";
    homepage = "https://github.com/domdfcoding/handy-archives";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
