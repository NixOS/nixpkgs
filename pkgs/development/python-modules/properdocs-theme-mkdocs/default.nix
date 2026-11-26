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
  pname = "properdocs-theme-mkdocs";
  version = "1.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "properdocs";
    repo = "properdocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACEgR9oNMPEDMLxeSJhNO7dJZBpTOiusfpE7XaXuztE=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/properdocs-theme-mkdocs";

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
    "properdocs_theme_mkdocs"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "'mkdocs' theme for ProperDocs, originally made for MkDocs";
    homepage = "https://github.com/properdocs/properdocs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
