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
  version = "2.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57c84f50a04d7825515e4dbf3a31c70cc44414394a71608dee6cfde469e81766";
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
