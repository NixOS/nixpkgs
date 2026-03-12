{
  lib,
  attrs,
  buildPythonPackage,
  cattrs,
  fetchFromGitHub,
  flit-core,
  importlib-resources,
  jsonschema,
  pyhamcrest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lsprotocol";
  version = "2025.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "lsprotocol";
    tag = version;
    hash = "sha256-DrWXHMgDZSQQ6vsmorThMrUTX3UQU+DajSEOdxoXrFQ=";
  };

  sourceRoot = "${src.name}/packages/python";

  build-system = [
    flit-core
  ];

  dependencies = [
    attrs
    cattrs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    importlib-resources
    jsonschema
    pyhamcrest
  ];

  disabledTests = [
    # cattrs.errors.StructureHandlerNotFoundError: Unsupported type:
    # typing.Union[str, lsprotocol.types.NotebookDocumentFilter_Type1,
    # lsprotocol.types.NotebookDocumentFilter_Type2,
    # lsprotocol.types.NotebookDocumentFilter_Type3, NoneType]. Register
    # a structure hook for it.
    "test_notebook_sync_options"
  ];

  preCheck = ''
    cd ../../
  '';

  pythonImportsCheck = [ "lsprotocol" ];

  meta = {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/microsoft/lsprotocol";
    changelog = "https://github.com/microsoft/lsprotocol/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      doronbehar
      fab
    ];
  };
}
