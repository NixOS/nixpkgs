{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  beanquery,
  fava,
  hatch-vcs,
  hatchling,
  pyyaml,
}:
buildPythonPackage rec {
  pname = "fava-dashboards";
  version = "2.0.0b7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-dashboards";
    tag = "v${version}";
    hash = "sha256-DtytD8LA/DoyBwXjpSHaEzwf7YJscV0yvMn9EpL6eh8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    beanquery
    fava
    pyyaml
  ];

  pythonImportsCheck = [ "fava_dashboards" ];

  meta = {
    description = "Custom Dashboards for Beancount in Fava";
    homepage = "https://github.com/andreasgerstmayr/fava-dashboards";
    changelog = "https://github.com/andreasgerstmayr/fava-dashboards/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
