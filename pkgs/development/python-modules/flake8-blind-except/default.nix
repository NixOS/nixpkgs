{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "flake8-blind-except";
  version = "0.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "02a860a1a19cb602c006a3fe0778035b0d14d3f57929b4b798bc7d6684f204e5";
  };
  meta = {
    homepage = "https://github.com/elijahandrews/flake8-blind-except";
    description = "A flake8 extension that checks for blind except: statements";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
