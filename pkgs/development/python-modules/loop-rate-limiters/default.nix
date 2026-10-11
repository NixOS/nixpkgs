{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytest-asyncio,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "loop-rate-limiters";
  version = "1.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stephane-caron";
    repo = "loop-rate-limiters";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r/Kj8rU3mDWwNKZnbM4NWbCFTi5C6wH7qkfjcjT4bZA=";
  };

  build-system = [
    flit-core
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: There is no current event loop in thread 'MainThread'.
    "test_period_dt"
  ];

  pythonImportsCheck = [
    "loop_rate_limiters"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Loop rate limiters in Python with an API similar to rospy.Rate";
    homepage = "https://github.com/stephane-caron/loop-rate-limiters";
    changelog = "https://github.com/stephane-caron/loop-rate-limiters/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
