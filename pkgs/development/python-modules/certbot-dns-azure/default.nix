{
  lib,
  fetchPypi,
  buildPythonPackage,
  acme,
  certbot,
  pytestCheckHook,
  python3Packages,
  powershell,
}:
buildPythonPackage rec {
  pname = "certbot-dns-azure";
  version = "2.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BqIC3lBt1ChvwIGrDimiliqGE7oZNEEgtWRIoseOTm8=";
  };

  propagatedBuildInputs = [
    acme
    certbot
    powershell
    python3Packages.azure-core
    python3Packages.azure-identity
    python3Packages.azure-mgmt-dns
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = true;

  pytestFlagsArray = [
    "--ignore=setup.py"
    "-v"
  ];

  checkPhase = ''
    pytest -rA tests/
  '';

  pythonImportsCheck = [ "certbot_dns_azure" ];

  meta = with lib; {
    description = "Azure DNS Authenticator plugin for Certbot";
    homepage = "https://github.com/terricain/certbot-dns-azure";
    license = licenses.asl20;
    maintainers = with maintainers; [ naillizard ];
  };
}
