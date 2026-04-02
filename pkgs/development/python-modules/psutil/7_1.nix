{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "7.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "giampaolo";
    repo = "psutil";
    tag = "release-${version}";
    hash = "sha256-LyGnLrq+SzCQmz8/P5DOugoNEyuH0IC7uIp8UAPwH0U=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Segfaults on darwin:
  # https://github.com/giampaolo/psutil/issues/1715
  doCheck = !stdenv.hostPlatform.isDarwin;

  # Only test_system.py is enabled; other test files require hardware access
  # or fail in the sandbox (e.g. process, network, memory tests).
  enabledTestPaths = [
    # $out is needed because psutil 7.1.x has tests inside the psutil package
    # (not top-level like 7.2.x) and C extensions are only in the installed output
    "${placeholder "out"}/${python.sitePackages}/psutil/tests/test_system.py"
  ];

  disabledTests = [
    # Some of the tests have build-system hardware-based impurities (like
    # reading temperature sensor values).  Disable them to avoid the failures
    # that sometimes result.
    "cpu_freq"
    "cpu_times"
    "disk_io_counters"
    "sensors_battery"
    "sensors_temperatures"
    "user"
    "test_disk_partitions" # problematic on Hydra's Linux builders, apparently
  ];

  pythonImportsCheck = [ "psutil" ];

  meta = {
    description = "Process and system utilization information interface";
    homepage = "https://github.com/giampaolo/psutil";
    changelog = "https://github.com/giampaolo/psutil/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ matteopacini ];
  };
}
