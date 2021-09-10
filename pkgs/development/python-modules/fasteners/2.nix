{ lib
, buildPythonPackage
, fetchPypi
, six
, monotonic
, testtools
, nose
, futures ? null
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a176da6b70df9bb88498e1a18a9e4a8579ed5b9141207762368a1017bf8f5ef";
  };

  propagatedBuildInputs = [
    six
    monotonic
  ];

  checkInputs = [
    testtools nose futures
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "A python package that provides useful locks";
    longDescription = ''
      Python standard library provides a lock for threads (both a reentrant one, and a non-reentrant one, see below). Fasteners extends this, and provides a lock for processes, as well as Reader Writer locks for both threads and processes.
    '';
    homepage = "https://github.com/harlowja/fasteners";
    license = licenses.asl20;
  };
}
