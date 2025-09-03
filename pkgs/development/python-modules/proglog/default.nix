{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  tqdm,
}:

buildPythonPackage rec {
  pname = "proglog";
  version = "0.1.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nh7gdHIcJ3uJt1wGEzbLjF8ofJKwQ++lYsz3hmzakxw=";
  };

  build-system = [ setuptools ];

  dependencies = [ tqdm ];

  meta = with lib; {
    description = "Logs and progress bars manager for Python";
    homepage = "https://github.com/Edinburgh-Genome-Foundry/Proglog";
    license = licenses.mit;
  };
}
