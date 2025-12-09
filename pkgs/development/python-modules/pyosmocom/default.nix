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
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitea {
    domain = "gitea.osmocom.org";
    owner = "osmocom";
    repo = "pyosmocom";
    rev = version;
    hash = "sha256-RPhJyBqPSzDr9xoeKAPDj/fY1q6gnzvF+7dP7+KAdGw=";
    # 404 not found: https://gitea.osmocom.org/osmocom/pyosmocom/archive/refs/tags/0.0.9.tar.gz
    forceFetchGit = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    construct
    gsm0338
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python osmocom core libraries";
    homepage = "https://gitea.osmocom.org/osmocom/pyosmocom";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
