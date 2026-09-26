{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  typer,
  pyinstaller,
  tox,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygrister";
  version = "0.10.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ricpol";
    repo = "pygrister";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7NIiHbE9LQimStSpZrCEoWFdfpfrrS7TIctfv4y0Yqc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    typer
  ];

  optional-dependencies = {
    devel = [
      pyinstaller
      tox
    ];
  };

  pythonImportsCheck = [
    "pygrister"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python client for the Grist API";
    homepage = "https://github.com/ricpol/pygrister";
    changelog = "https://github.com/ricpol/pygrister/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sinavir ];
  };
})
