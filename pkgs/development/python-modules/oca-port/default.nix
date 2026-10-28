{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  gitpython,
  giturlparse,
  git-filter-repo,
  lib,
  nix-update-script,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "oca-port";
  version = "0.24";
  pyproject = true;

  src = fetchFromGitHub {
    inherit version;
    owner = "OCA";
    repo = "oca-port";
    tag = "v${version}";
    hash = "sha256-JTxUn0XvPg6Y1pe+t14j3ZYZ3A/KMA2SH3B1MffW3Gc=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    click
    giturlparse
    gitpython
    requests
    git-filter-repo
  ];

  passthru.updateScript = nix-update-script { };

  pythonImportsCheck = [ "oca_port" ];

  meta = {
    description = "Tool helping to port an addon or missing commits of an addon from one branch to another";
    homepage = "https://github.com/OCA/oca-port";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
