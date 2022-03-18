{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "flake8-blind-except";
  version = "0.2.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8lpXWp3LPus8dgv5wi22C4taIxICJO0fqppD913X3RY=";
  };
  meta = {
    homepage = "https://github.com/elijahandrews/flake8-blind-except";
    description = "A flake8 extension that checks for blind except: statements";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
