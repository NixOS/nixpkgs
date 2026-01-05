{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  beanquery,
  fava,
  hatch-vcs,
  hatchling,
  pyyaml,
}:
buildPythonPackage (finalAttrs: {
  pname = "fava-dashboards";
  version = "2.0.0b2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-dashboards";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JvvGIHALMHewx4vYdjzZPAYz+FhXzX/vgbaQIcRvbus=";
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
    changelog = "https://github.com/andreasgerstmayr/fava-dashboards/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
