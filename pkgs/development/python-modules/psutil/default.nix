{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27, python
, darwin
, pytestCheckHook
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

  # arch doesn't report frequency is the same way
  # tests segfaults on darwin https://github.com/giampaolo/psutil/issues/1715
  doCheck = !stdenv.isDarwin && stdenv.isx86_64;
  checkInputs = [ pytestCheckHook ]
    ++ lib.optionals isPy27 [ mock ipaddress unittest2 ];
  pytestFlagsArray = [
    "$out/${python.sitePackages}/psutil/tests/test_system.py"
  ];
  # disable tests which don't work in sandbox
  # cpu_times is flakey on darwin
  disabledTests = [
    "user"
    "disk_io_counters"
    "sensors_battery"
    "cpu_times"
    "cpu_freq"
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.IOKit ];

  pythonImportsCheck = [ "psutil" ];

  meta = with lib; {
    description = "Process and system utilization information interface for python";
    homepage = "https://github.com/giampaolo/psutil";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
