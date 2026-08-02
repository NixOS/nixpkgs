{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygments-style-github";
  version = "0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D8q9IxR9VMhiQPYhZ4xTyZin3vqg0naRHB8t7wpF9Kc=";
  };

  build-system = [ setuptools ];

  dependencies = [ pygments ];

  # no tests exist on upstream repo
  doCheck = false;

  pythonImportsCheck = [ "pygments_style_github" ];

  meta = {
    description = "Port of the github color scheme for pygments";
    homepage = "https://github.com/hugomaiavieira/pygments-style-github";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
