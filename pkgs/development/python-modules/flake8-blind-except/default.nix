{
  lib,
  fetchPypi,
  buildPythonPackage,
  pycodestyle,
}:

buildPythonPackage rec {
  pname = "flake8-blind-except";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8lpXWp3LPus8dgv5wi22C4taIxICJO0fqppD913X3RY=";
  };

  propagatedBuildInputs = [ pycodestyle ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "flake8_blind_except" ];

  meta = {
    description = "Flake8 extension that checks for blind except: statements";
    homepage = "https://github.com/elijahandrews/flake8-blind-except";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johbo ];
  };
}
