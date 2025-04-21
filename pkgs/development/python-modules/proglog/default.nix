{
  lib,
  fetchPypi,
  buildPythonPackage,
  tqdm,
}:

buildPythonPackage rec {
  pname = "proglog";
  version = "0.1.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zjWg+dEVPmnQBjza5uby2HCPoKWI/E4IlQG3cAXnKIQ=";
  };

  propagatedBuildInputs = [ tqdm ];

  meta = with lib; {
    description = "Logs and progress bars manager for Python";
    homepage = "https://github.com/Edinburgh-Genome-Foundry/Proglog";
    license = licenses.mit;
  };
}
