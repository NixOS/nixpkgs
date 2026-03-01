{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lazy,
  packaging-legacy,
  pytestCheckHook,
  requests,
  setuptools-changelog-shortener,
  setuptools,
  tomli,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "devpi-common";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    tag = "common-${finalAttrs.version}";
    hash = "sha256-YFY2iLnORzFxnfGYU2kCpJL8CZi+lALIkL1bRpfd4NE=";
  };

  sourceRoot = "${finalAttrs.src.name}/common";

  build-system = [
    setuptools
    setuptools-changelog-shortener
  ];

  dependencies = [
    lazy
    packaging-legacy
    requests
    tomli
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "devpi_common" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/devpi/devpi";
    description = "Utilities jointly used by devpi-server and devpi-client";
    changelog = "https://github.com/devpi/devpi/blob/common-${finalAttrs.version}/common/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      confus
      lewo
      makefu
    ];
  };
})
