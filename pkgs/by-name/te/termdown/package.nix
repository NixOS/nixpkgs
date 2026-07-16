{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "termdown";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trehn";
    repo = "termdown";
    tag = finalAttrs.version;
    hash = "sha256-G2YOAC+b++oQUicZcY28qVDy2XqW2SuzhXcVqeSQkh8=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    art
    pillow
    python-dateutil
  ];

  meta = {
    changelog = "https://github.com/trehn/termdown/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Starts a countdown to or from TIMESPEC";
    mainProgram = "termdown";
    longDescription = "Countdown timer and stopwatch in your terminal";
    homepage = "https://github.com/trehn/termdown";
    license = lib.licenses.gpl3;
  };
})
