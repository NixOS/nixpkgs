{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  django,
}:

buildPythonPackage rec {
  pname = "openwisp_controller";
  version = "1.1";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5KJR2b+AxonytE22c7AOC6/CnaPDyT5hhrcIHnpxh8o=";
  };

  propagatedBuildInputs = [ django ];

  nativeBuildInputs = [
    setuptools-scm
    setuptools
  ];

  pythonImportsCheck = [ "openwisp_controller" ];

  meta = {
    homepage = "https://github.com/openwisp/openwisp-controller";
    description = "Network and WiFi controller: provisioning, configuration management and updates, (pull via openwisp-config or push via SSH), x509 PKI management and more";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ youhaveme9 ];
  };
}
