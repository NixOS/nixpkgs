{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "termdown";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trehn";
    repo = "termdown";
    tag = finalAttrs.version;
    hash = "sha256-PYYoKSjVyBrNAcYSdb+KTeyaum5ZRLu6q8C3r5twm5U=";
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
