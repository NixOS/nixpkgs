{
  lib,
  buildPythonPackage,
  fetchPypi,
  lazy,
  packaging-legacy,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools-changelog-shortener,
  setuptools,
  tomli,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "devpi-common";
    inherit version;
    hash = "sha256-WNf3YeP+f9/kScSmqeI1DU3fvrZssPbSCAJRQpQwMNM=";
  };

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

  meta = with lib; {
    homepage = "https://github.com/devpi/devpi";
    description = "Utilities jointly used by devpi-server and devpi-client";
    changelog = "https://github.com/devpi/devpi/blob/common-${version}/common/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [
      lewo
      makefu
    ];
  };
}
