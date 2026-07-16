{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "msrplib";
  version = "0.21.0-unstable-2026-07-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-msrplib";
    # no tag pushed for version 0.21.1 release, and commit title is wrong
    rev = "1b50e00b2b242be41287b3e3ae3ef02c5a7b96e6";
    hash = "sha256-HmIuJl/H94GX0caT+uKriz8RMkpzuFgsPPyPhwo3kHM=";
  };

  build-system = [
    setuptools
  ];

  # only test requires networking
  doCheck = false;

  pythonImportsCheck = [ "msrplib" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "MSRP (RFC4975) client library";
    homepage = "https://github.com/AGProjects/python3-msrplib";
    license = lib.licenses.lgpl21Plus;
    teams = [
      lib.teams.ngi
    ];
  };
}
