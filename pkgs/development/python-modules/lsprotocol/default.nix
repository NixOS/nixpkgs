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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "lsprotocol";
  version = "2025.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "lsprotocol";
    tag = version;
    hash = "sha256-DrWXHMgDZSQQ6vsmorThMrUTX3UQU+DajSEOdxoXrFQ=";
  };

  postPatch = ''
    pushd packages/python
  '';

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
    "test_notebook_sync_options"
  ];

  preCheck = ''
    popd
  '';

  pythonImportsCheck = [ "lsprotocol" ];

  meta = with lib; {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/microsoft/lsprotocol";
    changelog = "https://github.com/microsoft/lsprotocol/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      doronbehar
      fab
    ];
  };
}
