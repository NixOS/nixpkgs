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
  version = "0-unstable-2025-09-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-dashboards";
    rev = "73bdfe25226a780a9e4d1bfe59fce8d0573c33b0";
    sha256 = "sha256-OVso9xK/7TQZc/mps7ADZ+ErflBLpyZBk09GfhlMY/8";
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
