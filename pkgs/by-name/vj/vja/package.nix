{
  lib,
  python3,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vja";
  version = "4.10.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ce72";
    repo = "vja";
    tag = version;
    hash = "sha256-J2GX0t7hPLqqI2n8H0kDboGfpRff3+lHM3026fTX5rs=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    click
    click-aliases
    parsedatetime
    python-dateutil
    requests
  ];

  pythonImportsCheck = [
    "vja"
  ];

  meta = {
    description = "Command line interface for Vikunja";
    homepage = "https://gitlab.com/ce72/vja";
    changelog = "https://gitlab.com/ce72/vja/-/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "vja";
    maintainers = with lib.maintainers; [ iv-nn ];
  };
}
