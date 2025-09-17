{
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  mkdocs,
  playwright,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mkdocs-swagger-ui-tag";
  version = "0.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Blueswen";
    repo = "mkdocs-swagger-ui-tag";
    tag = "v${version}";
    hash = "sha256-5bQJMmPrweIAR42bjfWHUqnSy4IFoTpFoBaV+Gj/OGI=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    hatchling
    mkdocs
  ];

  nativeCheckInputs = [
    playwright
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mkdocs_swagger_ui_tag" ];

  disabledTests = [
    # Don't actually build results
    "test_material"
    "test_material_dark_scheme_name"
    "test_template"
    "test_mkdocs_screenshot"
    "test_no_console_errors"
  ];

  meta = with lib; {
    description = "MkDocs plugin supports for add Swagger UI in page";
    homepage = "https://github.com/Blueswen/mkdocs-swagger-ui-tag";
    changelog = "https://github.com/blueswen/mkdocs-swagger-ui-tag/blob/${src.tag}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
  };
}
