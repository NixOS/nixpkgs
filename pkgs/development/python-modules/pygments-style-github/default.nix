{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
}:

buildPythonPackage rec {
  pname = "pygments-style-github";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D8q9IxR9VMhiQPYhZ4xTyZin3vqg0naRHB8t7wpF9Kc=";
  };

  # no tests exist on upstream repo
  doCheck = false;

  propagatedBuildInputs = [ pygments ];

  pythonImportsCheck = [ "pygments_style_github" ];

  meta = with lib; {
    description = "Port of the github color scheme for pygments";
    homepage = "https://github.com/hugomaiavieira/pygments-style-github";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
