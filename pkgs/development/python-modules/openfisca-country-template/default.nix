{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  openfisca-core,
}:

buildPythonPackage rec {
  pname = "openfisca-country-template";
  version = "8.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openfisca";
    repo = "country-template";
    tag = version;
    hash = "sha256-AUk2v55+xkwSykPu+p+TDb4tCmjz7uWSVvr9btxo74Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    openfisca-core
  ] ++ openfisca-core.optional-dependencies.web-api;

  pythonImportsCheck = [
    "openfisca_country_template"
  ];

  meta = {
    description = "Start modelling the tax and benefit system of your country in a few minutes";
    homepage = "https://github.com/openfisca/country-template";
    changelog = "https://github.com/openfisca/country-template/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
