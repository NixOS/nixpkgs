{
  lib,
  python3Packages,
  fetchFromGitLab,
}:

python3Packages.buildPythonApplication rec {
  pname = "undertime";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "anarcat";
    repo = "undertime";
    tag = version;
    hash = "sha256-sQI+fpg5PFGCsS9xikMTi4Ad76TayP13UgZag6CRBxE=";
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
    changelog = "https://gitlab.com/anarcat/undertime/-/raw/${version}/debian/changelog";
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
}
