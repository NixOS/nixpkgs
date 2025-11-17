{
  lib,
  python3Packages,
  fetchFromGitHub,
  shellcheck,
  makeWrapper,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "yaml-shellcheck";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mschuett";
    repo = "yaml-shellcheck";
    tag = "v${version}";
    hash = "sha256-I+HkpUV1OCXau+i/ni0WX2bzTPFI705hrmVL9W9Co+8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"ruamel.yaml" = "0.18.15"' '"ruamel.yaml" = "0.18.16"'
  '';

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    ruamel-yaml
  ];

  pythonImportsCheck = [
    "yaml_shellcheck"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram  $out/bin/${meta.mainProgram} --prefix PATH : "${lib.makeBinPath [ shellcheck ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wrapper script to run shellcheck on YAML CI-config files";
    homepage = "https://github.com/mschuett/yaml-shellcheck";
    changelog = "https://github.com/mschuett/yaml-shellcheck/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "yaml_shellcheck";
  };
}
