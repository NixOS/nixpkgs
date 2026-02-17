{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  pydantic,
  python-dateutil,
  typing-extensions,
  urllib3,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lance-namespace";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance-namespace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cUwvPPOQemusthuTMttdojqApnWL4JmCdSB5oGZCfZ8=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/lance_namespace_urllib3_client";

  build-system = [
    hatchling
  ];

  dependencies = [
    pydantic
    python-dateutil
    typing-extensions
    urllib3
  ];

  pythonImportsCheck = [ "lance_namespace_urllib3_client" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Lance namespace OpenAPI specification";
    homepage = "https://github.com/lancedb/lance-namespace/tree/main/python/lance_namespace_urllib3_client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
