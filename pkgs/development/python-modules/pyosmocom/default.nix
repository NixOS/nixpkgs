{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  nix-update-script,

  setuptools,
  pytestCheckHook,

  construct,
  gsm0338,
}:

buildPythonPackage rec {
  pname = "pyosmocom";
  version = "0.0.12";
  pyproject = true;

  src = fetchFromGitea {
    domain = "gitea.osmocom.org";
    owner = "osmocom";
    repo = "pyosmocom";
    rev = version;
    hash = "sha256-9PRDUUjLSNloFLJBWNhH/yDZUNwFUGFb+Ayy6RDl/hI=";
    # 404 not found: https://gitea.osmocom.org/osmocom/pyosmocom/archive/refs/tags/0.0.12.tar.gz
    forceFetchGit = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    construct
    gsm0338
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "osmocom.utils"
    "osmocom.construct"
    "osmocom.tlv"
    "osmocom.gsmtap"
    "osmocom.gsup"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python osmocom core libraries";
    homepage = "https://gitea.osmocom.org/osmocom/pyosmocom";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jeyemwey ];
  };
}
