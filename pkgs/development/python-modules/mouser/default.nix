{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  click,
  requests,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mouser";
  version = "0.1.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sparkmicro";
    repo = "mouser-api";
    tag = finalAttrs.version;
    hash = "sha256-E8RYtuY4OONl9fI25I2utk3JfElVJHlpfCuOPvHo5Dg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    click
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "mouser" ];
  disabledTests = [
    # Search tests require an API key and network access
    "search"
  ];

  meta = {
    description = "Mouser Python API";
    homepage = "https://github.com/sparkmicro/mouser-api";
    changelog = "https://github.com/sparkmicro/mouser-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gigahawk
    ];
  };
})
