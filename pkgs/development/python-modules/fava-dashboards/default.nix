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
  version = "0-unstable-2025-08-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-dashboards";
    rev = "f40c91c59bdaba1cb9646d7dc21d09885fe088fe";
    sha256 = "sha256-btflbN+dr0GWSIHI6WmghthKZLPOQpbAQDM9ZyXDeso=";
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

  doCheck = false;

  pythonImportsCheck = [ "fava_dashboards" ];

  meta = {
    homepage = "https://github.com/andreasgerstmayr/fava-dashboards";
    description = "Custom Dashboards for Beancount in Fava";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seberm ];
  };
}
