{
  lib,
  python3Packages,
  fetchFromGitLab,
}:

python3Packages.buildPythonApplication rec {
  pname = "undertime";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "anarcat";
    repo = pname;
    rev = version;
    hash = "sha256-BshgSnYaeX01KQ1fggB+yXEfg3Trhpcf/k4AmBDPxy8=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
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
    description = "pick a meeting time across timezones from the commandline";
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
