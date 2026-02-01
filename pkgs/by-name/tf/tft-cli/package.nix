{
  lib,
  fetchFromGitLab,
  python3Packages,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "tft-cli";
  version = "0.0.37";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "testing-farm";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NmRVe0xjGEU18ZtzPCBGsWlSzXIl1VgunAZ4tDFH5gY=";
  };

  build-system = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    click
    typer
    dynaconf
    colorama
    requests
    rich
    ruamel-yaml
    shellingham
    pendulum
    python-dotenv
    keyring
    cryptography
  ];

  meta = {
    homepage = "https://testing-farm.io/";
    changelog = "https://gitlab.com/testing-farm/cli/-/releases/${finalAttrs.src.tag}";
    description = "Testing Farm CLI tool";

    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      mfocko
      thrix
    ];
    mainProgram = "testing-farm";
  };
})
