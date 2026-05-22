{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  lazy,
  requests,
  tomli,

  # tests
  packaging-legacy,
  pytestCheckHook,
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_changelog_shortener",' ""
  '';

  sourceRoot = "${finalAttrs.src.name}/common";

  build-system = [
    setuptools
  ];

  dependencies = [
    lazy
    requests
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
    packaging-legacy
  ];

  pythonImportsCheck = [ "devpi_common" ];

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
