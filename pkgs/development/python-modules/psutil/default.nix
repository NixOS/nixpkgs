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

  # arch doesn't report frequency is the same way
  # tests segfaults on darwin https://github.com/giampaolo/psutil/issues/1715
  doCheck = !stdenv.isDarwin && stdenv.isx86_64;
  checkInputs = [ pytest ]
    ++ lib.optionals isPy27 [ mock ipaddress unittest2 ];
  # out must be referenced as test import paths are relative
  # disable tests which don't work in sandbox
  # cpu_times is flakey on darwin
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
