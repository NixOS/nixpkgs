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

buildPythonPackage rec {
  pname = "lance-namespace";
  version = "0.0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance-namespace";
    tag = "v${version}";
    hash = "sha256-KbQ1xXD/+8oOcbhc+dvk68ZF0daWm7In0y0NVsSfp9U=";
  };

  sourceRoot = "${src.name}/python/lance_namespace_urllib3_client";

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
}
