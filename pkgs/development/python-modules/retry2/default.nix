{
  lib,
  buildPythonPackage,
  decorator,
  fetchFromGitHub,
  pbr,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "retry2";
  version = "0.9.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "eSAMTrade";
    repo = "retry";
    tag = version;
    hash = "sha256-RxOEekkmMRl2OQW2scFWbMQiFXcH0sbd+k9R8uul0uY=";
  };

  env.PBR_VERSION = version;

  build-system = [ pbr ];

  dependencies = [ decorator ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "retry" ];

  meta = {
    description = "Retry decorator";
    homepage = "https://github.com/eSAMTrade/retry";
    changelog = "https://github.com/eSAMTrade/retry/blob/${src.rev}/ChangeLog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
