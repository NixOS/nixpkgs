{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "msrplib";
  version = "0.21.0-unstable-2021-06-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-msrplib";
    # no tag pushed for version 0.21.1 release, and commit title is wrong
    rev = "5bd069620d436d5a65e1c369e43cc6b88857fb9e";
    hash = "sha256-z0gF/oQW/h3qiCL1cFWBPK7JYzLCNAD7/dg7HfY4rig=";
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
