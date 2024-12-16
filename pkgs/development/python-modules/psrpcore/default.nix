{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  powershell,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  xmldiff,
}:

buildPythonPackage rec {
  pname = "psrpcore";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "psrpcore";
    rev = "refs/tags/v${version}";
    hash = "sha256-svfqTOKKFKMphIPnvXfAbPZrp1GTV2D+33I0Rajfv1Y=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    powershell
    pytestCheckHook
    xmldiff
  ];

  pythonImportsCheck = [ "psrpcore" ];

  meta = with lib; {
    description = "Library for the PowerShell Remoting Protocol (PSRP)";
    homepage = "https://github.com/jborean93/psrpcore";
    changelog = "https://github.com/jborean93/psrpcore/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
