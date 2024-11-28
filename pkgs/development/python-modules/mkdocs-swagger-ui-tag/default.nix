{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  pathspec,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mkdocs-swagger-ui-tag";
  version = "0.6.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Blueswen";
    repo = "mkdocs-swagger-ui-tag";
    rev = "refs/tags/v${version}";
    hash = "sha256-hxf7onjH26QsdB19r71NSC/67u+pEYdJo3e4OvWGgtI=";
  };

  propagatedBuildInputs = [
    mkdocs
    beautifulsoup4
  ];

  nativeCheckInputs = [
    pathspec
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mkdocs_swagger_ui_tag" ];

  disabledTests = [
    # Don't actually build results
    "test_material"
    "test_material_dark_scheme_name"
    "test_template"
  ];

  meta = with lib; {
    description = "MkDocs plugin supports for add Swagger UI in page";
    homepage = "https://github.com/Blueswen/mkdocs-swagger-ui-tag";
    changelog = "https://github.com/blueswen/mkdocs-swagger-ui-tag/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
  };
}
