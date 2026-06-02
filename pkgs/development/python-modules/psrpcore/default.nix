{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  powershell,
  pytestCheckHook,
  setuptools,
  xmldiff,
}:

buildPythonPackage rec {
  pname = "psrpcore";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "psrpcore";
    tag = "v${version}";
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

  meta = {
    description = "Library for the PowerShell Remoting Protocol (PSRP)";
    homepage = "https://github.com/jborean93/psrpcore";
    changelog = "https://github.com/jborean93/psrpcore/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
