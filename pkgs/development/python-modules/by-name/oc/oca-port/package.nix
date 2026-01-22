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
  version = "0.18";
  pyproject = true;

  src = fetchFromGitHub {
    inherit version;
    owner = "OCA";
    repo = "oca-port";
    tag = "v${version}";
    hash = "sha256-r32ePlbg0GjryB5HDx0nQTq71lG/o+4sUFRdKW/K5ys=";
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
