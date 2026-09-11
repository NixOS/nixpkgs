{
  lib,
  python3Packages,
  fetchFromGitLab,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "undertime";
  version = "4.3.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "anarcat";
    repo = "undertime";
    tag = finalAttrs.version;
    hash = "sha256-TOrsQIi+ZcUQUGhb+iX8seuwNfKrrBL2DIcLK9wyjn0=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    dateparser
    ephem
    pytz
    pyyaml
    termcolor
    tabulate
    tzlocal
  ];

  meta = {
    changelog = "https://gitlab.com/anarcat/undertime/-/raw/${finalAttrs.version}/debian/changelog";
    description = "Pick a meeting time across timezones from the commandline";
    homepage = "https://gitlab.com/anarcat/undertime";
    longDescription = ''
      Undertime draws a simple 24 hour table of matching times across
      different timezones or cities, outlining waking hours. This allows
      picking an ideal meeting date across multiple locations for teams
      working internationally.
    '';
    license = lib.licenses.agpl3Only;
    mainProgram = "undertime";
    maintainers = with lib.maintainers; [ dvn0 ];
  };
})
