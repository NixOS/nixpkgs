{
  lib,
  buildPythonPackage,
  decorator,
  fetchFromGitHub,
  pbr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "retry2";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eSAMTrade";
    repo = "retry";
    tag = finalAttrs.version;
    hash = "sha256-RxOEekkmMRl2OQW2scFWbMQiFXcH0sbd+k9R8uul0uY=";
  };

  env.PBR_VERSION = finalAttrs.version;

  build-system = [ pbr ];

  dependencies = [ decorator ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "retry" ];

  meta = {
    description = "Retry decorator";
    homepage = "https://github.com/eSAMTrade/retry";
    changelog = "https://github.com/eSAMTrade/retry/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
