{
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  cython,
  numpy,
}:
buildPythonPackage rec {
  pname = "pymonocypher";
  version = "4.0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wCP+SUnnbPqnl+MMNoLZudGSPbGNL9zr2nU/Wpe3yo4=";
  };

  build-system = [
    cython
    setuptools-scm
  ];

  dependencies = [numpy];
}
