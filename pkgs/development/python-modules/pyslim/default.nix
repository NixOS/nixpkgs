{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  msprime,
  numpy,
  tskit,
}:

buildPythonPackage rec {
  pname = "pyslim";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T0ES0a7B4yTIUMXQgDEiIjxFJfZNmA7euTpa7JmryQU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    msprime
    tskit
    numpy
  ];

  # Requires non-packaged software SLiM
  doCheck = false;

  pythonImportsCheck = [ "pyslim" ];

  meta = {
    description = "Tools for dealing with tree sequences coming to and from SLiM";
    homepage = "https://github.com/tskit-dev/pyslim";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
