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
  version = "1.0.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-valAhPEVZNv/IYe85a88SGE+2/9O1omvBywz/HeeRco=";
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

  meta = with lib; {
    description = "Tools for dealing with tree sequences coming to and from SLiM";
    homepage = "https://github.com/tskit-dev/pyslim";
    license = licenses.mit;
    maintainers = with maintainers; [ alxsimon ];
  };
}
