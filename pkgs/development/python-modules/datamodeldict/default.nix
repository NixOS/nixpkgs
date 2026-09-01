{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "datamodeldict";
  version = "0.9.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "DataModelDict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4tyf3zlzxbtHkvADP+Kmw3/XMugAGi4FNO0qM16m8DU=";
  };

  build-system = [ uv-build ];

  dependencies = [ xmltodict ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "DataModelDict" ];

  meta = {
    description = "Class allowing for data models equivalently represented as Python dictionaries, JSON, and XML";
    homepage = "https://github.com/usnistgov/DataModelDict/";
    changelog = "https://github.com/usnistgov/DataModelDict/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
