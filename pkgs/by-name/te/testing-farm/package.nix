{
  lib,
  python3Packages,
  fetchFromGitLab,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "testing-farm";
  version = "0.0.38";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "testing-farm";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-guoZfFkx9VNXiJy61Cg08G/H4HIcSZ66J+US69SsioM=";
  };

  build-system = [
    python3Packages.poetry-core
    python3Packages.poetry-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    click
    colorama
    cryptography
    dynaconf
    keyring
    pendulum
    python-dotenv
    requests
    rich
    ruamel-yaml
    shellingham
    typer
  ];

  pythonImportsCheck = [
    "tft.cli"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Testing Farm's CLI tool";
    homepage = "https://testing-farm.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ WOnder93 ];
    mainProgram = "testing-farm";
  };
})
