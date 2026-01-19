{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  discordpy,
  lib,
}:
let
  pname = "reactionmenu";
  version = "3.1.7";
in
buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Defxult";
    repo = "reactionmenu";
    tag = "v${version}";
    hash = "sha256-ftRrpNOJIa2DSBr9YOH3Bhn8iXE1Pgtv0f57/rsCqJU=";
  };
  pyproject = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    discordpy
  ];

  pythonImportsCheck = [ "reactionmenu" ];

  meta = {
    description = "Library to create a discord.py 2.0+ paginator";
    longDescription = ''
      A Python library to create a discord.py 2.0+ paginator (reaction menu/buttons menu).
      Supports pagination with buttons, reactions, and category selection using selects.
    '';
    homepage = "https://github.com/Defxult/reactionmenu";
    changelog = "https://github.com/Defxult/reactionmenu/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amadaluzia ];
  };
}
