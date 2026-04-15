{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coq-tools";
  version = "0.0.42";
  pyproject = true;

  src = fetchPypi {
    pname = "coq_tools";
    inherit version;
    hash = "sha256-d+SAGmZKUQo2ZKuC91r/2RHDvi5GCIKGTxcuau1kN0U=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "coq_tools" ];

  meta = {
    description = "Tools for working with Coq proof assistant";
    homepage = "https://pypi.org/project/coq-tools/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
