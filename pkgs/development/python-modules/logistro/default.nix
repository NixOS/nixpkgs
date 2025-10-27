{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-git-versioning,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "logistro";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geopozo";
    repo = "logistro";
    tag = "v${version}";
    hash = "sha256-uh6FFRHIXaWckU3FmlQLEO/zOBief7BJH2SsVBnPxhc=";
  };

  build-system = [
    setuptools
    setuptools-git-versioning
  ];
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "logistro" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A lightweight wrapper over the built-in logging package";
    homepage = "https://github.com/geopozo/logistro";
    changelog = "https://github.com/geopozo/logistro/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
