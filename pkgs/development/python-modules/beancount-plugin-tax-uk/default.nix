{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beancount,
  click,
  fava,
  openpyxl,
  pandas,
  pytest-cov-stub,
  pytestCheckHook,
  python,
  setuptools,
  setuptools-scm,
  xlsxwriter,
}:

buildPythonPackage {
  pname = "beancount-plugin-tax-uk";
  version = "0-unstable-2026-07-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Evernight";
    repo = "beancount-plugin-tax-uk";
    rev = "b94287bab7566e48e710586d15c72ee6cfee503f";
    hash = "sha256-QygINKvR8kIoFsu4WM/L7JfNENcFJDNZ45Kli4Jdl08=";
  };

  pythonRemoveDeps = [
    "dataclasses"
    "uv"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    beancount
    click
    fava
    pandas
    xlsxwriter
  ];

  nativeCheckInputs = [
    openpyxl
    pytest-cov-stub
    pytestCheckHook
  ];

  # 'setuptools-scm' doesn't handle unstable-* versions
  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.0.1";

  postInstall = ''
    cp src/beancount_plugin_tax_uk/UKTaxPlugin.js $out/${python.sitePackages}/beancount_plugin_tax_uk/
    cp -r src/beancount_plugin_tax_uk/templates $out/${python.sitePackages}/beancount_plugin_tax_uk/
  '';

  pythonImportsCheck = [ "beancount_plugin_tax_uk" ];

  meta = {
    homepage = "https://github.com/Evernight/beancount-plugin-tax-uk";
    description = "Beancount plugin for generating informational UK tax report";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
