{
  lib,
  python3,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "vja";
  version = "6.0.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ce72";
    repo = "vja";
    tag = finalAttrs.version;
    hash = "sha256-wyKhDwqQXDU+DaVJo0LCyK1KV1vkRPbrUDs46x7hBEI=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    click
    click-aliases
    parsedatetime
    pyjwt
    python-dateutil
    requests
  ];

  pythonImportsCheck = [
    "vja"
  ];

  meta = {
    description = "Command line interface for Vikunja";
    homepage = "https://gitlab.com/ce72/vja";
    changelog = "https://gitlab.com/ce72/vja/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "vja";
    maintainers = with lib.maintainers; [ iv-nn ];
  };
})
