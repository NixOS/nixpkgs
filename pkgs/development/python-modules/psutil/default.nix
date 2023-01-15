{ lib
, stdenv
, buildPythonPackage
, CoreFoundation
, fetchPypi
, IOKit
, pytestCheckHook
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PX+XOetDXUsTOJRKviP0lYS95TlfJ0h9LuJa2ah3SmI=";
  };

  buildInputs =
    # workaround for https://github.com/NixOS/nixpkgs/issues/146760
    lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
      CoreFoundation
    ] ++ lib.optionals stdenv.isDarwin [
      IOKit
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Segfaults on darwin:
  # https://github.com/giampaolo/psutil/issues/1715
  doCheck = !stdenv.isDarwin;

  # In addition to the issues listed above there are some that occure due to
  # our sandboxing which we can work around by disabling some tests:
  # - cpu_times was flaky on darwin
  # - the other disabled tests are likely due to sanboxing (missing specific errors)
  pytestFlagsArray = [
    "$out/${python.sitePackages}/psutil/tests/test_system.py"
  ];

  # Note: $out must be referenced as test import paths are relative
  disabledTests = [
    "cpu_freq"
    "cpu_times"
    "disk_io_counters"
    "sensors_battery"
    "user"
    "test_disk_partitions" # problematic on Hydra's Linux builders, apparently
  ];

  pythonImportsCheck = [
    "psutil"
  ];

  meta = with lib; {
    description = "Process and system utilization information interface";
    homepage = "https://github.com/giampaolo/psutil";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
