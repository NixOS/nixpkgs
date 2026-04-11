{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "osmapi";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metaodi";
    repo = "osmapi";
    tag = "v${version}";
    hash = "sha256-eohhbKcTkgfM6IuQyeiASlCtrqUwb0aFXqUCkDyvsS0=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
    xmltodict
  ];

  pythonImportsCheck = [ "osmapi" ];

  meta = {
    description = "Python wrapper for the OSM API";
    homepage = "https://github.com/metaodi/osmapi";
    changelog = "https://github.com/metaodi/osmapi/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
