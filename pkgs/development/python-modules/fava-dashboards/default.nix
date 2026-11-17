{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  beanquery,
  fava,
  flask,
  hatch-vcs,
  hatchling,
  pyyaml,
}:
buildPythonPackage rec {
  pname = "fava-dashboards";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-dashboards";
    tag = "v${version}";
    hash = "sha256-1NJBV12/OIbJau2Z4RAp+QgV0jVlkznyDI/tWlfw2Bk=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    beanquery
    fava
    flask
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
