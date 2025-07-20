{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pytest-rerunfailures,
  setuptools,
  psutil,
  netcat,
  ps,
  python-daemon,
}:

buildPythonPackage rec {
  pname = "mirakuru";
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ClearcodeHQ";
    repo = "mirakuru";
    tag = "v${version}";
    hash = "sha256-R5prLIub2kVhsKRGWbZMf/v0U7oOBieoLiHwMRDEs0I=";
  };

  build-system = [ setuptools ];

  dependencies = [ psutil ];

  nativeCheckInputs = [
    netcat.nc
    ps
    python-daemon
    pytest-rerunfailures
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mirakuru" ];

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  __darwinAllowLocalNetworking = true;

  # Those are failing in the darwin sandbox with:
  # > ps: %mem: requires entitlement
  # > ps: vsz: requires entitlement
  # > ps: rss: requires entitlement
  # > ps: time: requires entitlement
  disabledTests = [
    "test_forgotten_stop"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_mirakuru_cleanup"
    "test_daemons_killing"
  ];

  meta = with lib; {
    homepage = "https://github.com/dbfixtures/mirakuru";
    description = "Process orchestration tool designed for functional and integration tests";
    changelog = "https://github.com/ClearcodeHQ/mirakuru/blob/v${version}/CHANGES.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
