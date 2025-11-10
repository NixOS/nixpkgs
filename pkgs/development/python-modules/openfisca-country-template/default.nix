{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  openfisca-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "openfisca-country-template";
  version = "8.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openfisca";
    repo = "country-template";
    tag = finalAttrs.version;
    hash = "sha256-9EP5RjyX2EfmxdWozP6eDeMREVduTD9vxpxdj1niLtg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    openfisca-core
  ]
  ++ openfisca-core.optional-dependencies.web-api;

  pythonImportsCheck = [
    "openfisca_country_template"
  ];

  meta = {
    description = "Start modelling the tax and benefit system of your country in a few minutes";
    homepage = "https://github.com/openfisca/country-template";
    changelog = "https://github.com/openfisca/country-template/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
