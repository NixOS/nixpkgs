{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  beancount,
  pdm-pep517,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "autobean";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SEIAROTg";
    repo = "autobean";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qc8erF9yF8HnxhKQmyTAbJ196C93NgiaDBr+7kBjLDs=";
  };

  patches = [
    (fetchpatch {
      name = "fix-include-fix-file-change-detection.patch";
      url = "https://github.com/SEIAROTg/autobean/commit/d111b3ca31ea783803b155c0980d422c002338ae.patch";
      hash = "sha256-o65xaQrX4Q+Soki8Y9J+tAKEDp771YNmk1eWAGiMNXQ=";
    })
  ];

  build-system = [
    pdm-pep517
  ];

  dependencies = [
    beancount
    python-dateutil
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTestPaths = [
    # https://github.com/SEIAROTg/autobean/issues/21
    "autobean/include/tests/test_runner.py"
  ];

  pythonImportsCheck = [ "autobean" ];

  meta = {
    homepage = "https://github.com/SEIAROTg/autobean";
    description = "Collection of plugins and scripts that help automating bookkeeping with beancount";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
