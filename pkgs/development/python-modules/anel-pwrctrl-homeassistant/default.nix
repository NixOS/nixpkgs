{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "anel-pwrctrl-homeassistant";
  version = "0.0.1.dev2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "anel_pwrctrl-homeassistant";
    hash = "sha256-AcsnYD9CeGAarm5QdweUF6CUFwUywhfmU46NG8+Cm4s=";
  };

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "anel_pwrctrl" ];

  meta = with lib; {
    description = "Discover and control ANEL NET-PwrCtrl devices";
    homepage = "https://github.com/mweinelt/anel-pwrctrl";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
