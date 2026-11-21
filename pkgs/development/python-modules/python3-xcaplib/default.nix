{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  twisted,
  python3-application,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "python3-xcaplib";
  # latest commit is needed for python 3.13 compat.
  version = "2.0.3b-unstable-2026-10-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-xcaplib";
    rev = "77e3ac088e80ef2df48bdac49e6523bdd245bb51";
    hash = "sha256-UUGvnkSIygPiPXbmgDCIen8y/WpvbYBecENz8ifxjMU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lxml
    twisted
    python3-application
  ];

  # the one and only upstream test relies on networking
  doCheck = false;

  pythonImportsCheck = [ "xcaplib" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "XCAP (RFC4825) client library";
    homepage = "https://github.com/AGProjects/python3-xcaplib";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.ngi ];
    maintainers = [ lib.maintainers.ethancedwards8 ];
    mainProgram = "xcapclient3";
  };
}
