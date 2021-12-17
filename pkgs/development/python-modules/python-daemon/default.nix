{ lib
, buildPythonPackage
, fetchPypi
, docutils
, lockfile
, mock
, pytest_4
, testscenarios
, testtools
, twine
}:

buildPythonPackage rec {
  pname = "python-daemon";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bda993f1623b1197699716d68d983bb580043cf2b8a66a01274d9b8297b0aeaf";
  };

  nativeBuildInputs = [
    twine
  ];

  propagatedBuildInputs = [
    docutils
    lockfile
  ];

  checkInputs = [
    pytest_4
    mock
    testscenarios
    testtools
  ];

  # tests disabled due to incompatibilities with testtools>=2.5.0
  checkPhase = ''
    runHook preCheck
    pytest -k ' \
      not detaches_process_context and \
      not standard_stream_file_descriptors and \
      not test_module_has_attribute and \
      not test_module_attribute_has_duck_type'
    runHook postCheck
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
    license = with licenses; [
      gpl3Plus
      asl20
    ];
    maintainers = with maintainers; [ ];
  };
}
