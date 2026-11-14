{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  setuptools,
  babel,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "properdocs-theme-readthedocs";
  version = "1.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "properdocs";
    repo = "properdocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACEgR9oNMPEDMLxeSJhNO7dJZBpTOiusfpE7XaXuztE=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/properdocs-theme-readthedocs";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"properdocs",' ""
  '';

  build-system = [
    hatchling
    setuptools
  ];

  dependencies = [
    babel
  ];

  pythonImportsCheck = [
    "properdocs_theme_readthedocs"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "'readthedocs' theme for ProperDocs, originally made for MkDocs";
    homepage = "https://github.com/properdocs/properdocs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
