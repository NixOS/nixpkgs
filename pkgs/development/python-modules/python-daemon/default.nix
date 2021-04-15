{ lib, buildPythonPackage, fetchPypi
, docutils
, lockfile
, mock
, pytest_4
, testscenarios
, twine
}:

buildPythonPackage rec {
  pname = "python-daemon";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bda993f1623b1197699716d68d983bb580043cf2b8a66a01274d9b8297b0aeaf";
  };

  nativeBuildInputs = [ twine ];
  propagatedBuildInputs = [ docutils lockfile ];

  checkInputs = [ pytest_4 mock testscenarios ];
  checkPhase = ''
    pytest -k 'not detaches_process_context \
                and not standard_stream_file_descriptors'
  '';

  pythonImportsCheck = [
    "daemon"
    "daemon.daemon"
    "daemon.pidfile"
    "daemon.runner"
  ];

  meta = with lib; {
    description = "Library to implement a well-behaved Unix daemon process";
    homepage = "https://pagure.io/python-daemon/";
    license = [ licenses.gpl3Plus licenses.asl20 ];
  };
}
