{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fava,
  pyyaml,
  beanquery,
  hatch-vcs,
  hatchling,
}:
buildPythonPackage {
  pname = "fava-dashboards";
  version = "0-unstable-2025-09-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-dashboards";
    rev = "96c815037c0afdc2b4adc220b9b1cb520499d555";
    sha256 = "sha256-fgNUhXyRe6268F7Uf+91Ksv4ThDgQbGeWfYlLZ5m9rI";
  };

  propagatedBuildInputs = [
    fava
    pyyaml
    beanquery
  ];

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "fava_dashboards" ];

  meta = {
    homepage = "https://github.com/andreasgerstmayr/fava-dashboards";
    description = "Custom Dashboards for Beancount in Fava";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seberm ];
  };
}
