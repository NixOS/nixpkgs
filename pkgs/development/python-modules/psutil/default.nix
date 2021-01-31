{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27, python
, darwin
, pytest
, mock
, ipaddress
, unittest2
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1immnj532bnnrh1qmk5q3lsw3san8qfk9kxy1cpmy0knmfcwp70c";
  };

  # We have many test failures on various parts of the package:
  #  - segfaults on darwin:
  #    https://github.com/giampaolo/psutil/issues/1715
  #  - swap (on linux) might cause test failures if it is fully used:
  #    https://github.com/giampaolo/psutil/issues/1911
  #  - some mount paths are required in the build sanbox to make the tests succeed:
  #    https://github.com/giampaolo/psutil/issues/1912
  doCheck = false;
  checkInputs = [ pytest ]
  ++ lib.optionals isPy27 [ mock ipaddress unittest2 ];
  # In addition to the issues listed above there are some that occure due to
  # our sandboxing which we can work around by disabling some tests:
  # - cpu_times was flaky on darwin
  # - the other disabled tests are likely due to sanboxing (missing specific errors)

  # Note: $out must be referenced as test import paths are relative
  checkPhase = ''
    pytest $out/${python.sitePackages}/psutil/tests/test_system.py \
      -k 'not user and not disk_io_counters and not sensors_battery and not cpu_times'
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.IOKit ];

  pythonImportsCheck = [ "psutil" ];

  meta = with lib; {
    description = "Process and system utilization information interface for python";
    homepage = "https://github.com/giampaolo/psutil";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
