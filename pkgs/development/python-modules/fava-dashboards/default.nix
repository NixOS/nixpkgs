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
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-dashboards";
    rev = "v${version}";
    hash = "sha256-0524Mx93bJ4DKTb3gYps+C7dzhzuNd7YIvqeCtZz2f0=";
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
