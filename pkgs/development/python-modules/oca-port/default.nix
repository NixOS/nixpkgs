{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  gitpython,
  giturlparse,
  lib,
  nix-update-script,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "oca-port";
  version = "0.19";
  pyproject = true;

  src = fetchFromGitHub {
    inherit version;
    owner = "OCA";
    repo = "oca-port";
    tag = "v${version}";
    hash = "sha256-5Iw9gbc8+x82huAMrqMHKXmJ12Drtaz3USdCucx1ruY=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    click
    giturlparse
    gitpython
    requests
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
