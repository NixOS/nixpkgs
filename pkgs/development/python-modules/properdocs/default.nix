{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  click,
  colorama,
  ghp-import,
  importlib-metadata,
  jinja2,
  markdown,
  markupsafe,
  packaging,
  pathspec,
  platformdirs,
  pyyaml,
  pyyaml-env-tag,
  watchdog,
  babel,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "properdocs";
  version = "1.6.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "properdocs";
    repo = "properdocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACEgR9oNMPEDMLxeSJhNO7dJZBpTOiusfpE7XaXuztE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    click
    colorama
    ghp-import
    importlib-metadata
    jinja2
    markdown
    markupsafe
    packaging
    pathspec
    platformdirs
    pyyaml
    pyyaml-env-tag
    watchdog
  ];

  optional-dependencies = {
    i18n = [
      babel
    ];
  };

  pythonImportsCheck = [
    "properdocs"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "";
    homepage = "https://github.com/properdocs/properdocs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
})
