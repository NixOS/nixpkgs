{
<<<<<<< HEAD
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  beautifulsoup4,

  # tests
  click,
  mkdocs,
  playwright,
  pytestCheckHook,
=======
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  mkdocs,
  playwright,
  pytestCheckHook,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "mkdocs-swagger-ui-tag";
  version = "0.7.2";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Blueswen";
    repo = "mkdocs-swagger-ui-tag";
    tag = "v${version}";
    hash = "sha256-5bQJMmPrweIAR42bjfWHUqnSy4IFoTpFoBaV+Gj/OGI=";
  };

<<<<<<< HEAD
  build-system = [
    hatchling
  ];

  dependencies = [
    beautifulsoup4
  ];

  nativeCheckInputs = [
    click
    mkdocs
=======
  propagatedBuildInputs = [
    beautifulsoup4
    hatchling
    mkdocs
  ];

  nativeCheckInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD

    # ValueError: I/O operation on closed file
    "test_error"
  ];

  meta = {
    description = "MkDocs plugin supports for add Swagger UI in page";
    homepage = "https://github.com/Blueswen/mkdocs-swagger-ui-tag";
    changelog = "https://github.com/blueswen/mkdocs-swagger-ui-tag/blob/${src.tag}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ snpschaaf ];
=======
  ];

  meta = with lib; {
    description = "MkDocs plugin supports for add Swagger UI in page";
    homepage = "https://github.com/Blueswen/mkdocs-swagger-ui-tag";
    changelog = "https://github.com/blueswen/mkdocs-swagger-ui-tag/blob/${src.tag}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
