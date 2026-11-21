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
  properdocs-theme-mkdocs,
  properdocs-theme-readthedocs,
  unittestCheckHook,
  mock,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "properdocs";
  version = "1.6.7";
  pyproject = true;

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

  nativeCheckInputs = [
    unittestCheckHook
    properdocs-theme-mkdocs
    properdocs-theme-readthedocs
    mock
  ]
  ++ finalAttrs.finalPackage.passthru.optional-dependencies.i18n;

  unittestFlags = [
    "--start-directory=properdocs"
    "--pattern=*tests.py"
    "-v"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Project documentation with Markdown";
    homepage = "https://github.com/properdocs/properdocs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
