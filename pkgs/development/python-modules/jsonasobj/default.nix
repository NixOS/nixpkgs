{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonasobj";
  version = "1.2.1";
  format = "setuptools";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HvTuR1Lyy9pvFmlJ1e11VH4qFqzwBzcImPQsN+bwSPo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "jsonasobj" ];

  meta = {
    description = "Treat JSON name/value pairs as Python object attributes";
    homepage = "https://github.com/hsolbrig/jsonasobj";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
