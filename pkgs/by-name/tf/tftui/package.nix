{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3Packages,
  enableUsageTracking ? false,
}:

python3Packages.buildPythonApplication rec {
  pname = "tftui";
  version = "0.13.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "idoavrah";
    repo = "terraform-tui";
    tag = "v${version}";
    hash = "sha256-xOlPuPVwfVT7jfBJPqZ5FbOs80HE0k2ZqcA+Jcxh9p4=";
  };

  pythonRelaxDeps = [
    "posthog"
    "textual"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    posthog
    pyperclip
    requests
    rich
    textual
  ];

  pythonImportsCheck = [
    "tftui"
  ];

  postInstall = lib.optionalString (!enableUsageTracking) ''
    wrapProgram $out/bin/tftui \
      --add-flags "--disable-usage-tracking"
  '';

  meta = {
    description = "Textual UI to view and interact with Terraform state";
    homepage = "https://github.com/idoavrah/terraform-tui";
    changelog = "https://github.com/idoavrah/terraform-tui/releases/tag/v${version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.bitnomial ];
    mainProgram = "tftui";
  };
}
