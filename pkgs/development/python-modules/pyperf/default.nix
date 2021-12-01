{ lib
, buildPythonPackage
, fetchPypi
, six
, statistics
, pythonOlder
, nose
, psutil
, contextlib2
, mock
, unittest2
, isPy27
, python
}:

buildPythonPackage rec {
  pname = "pyperf";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a85dd42e067131d5b26b71472336da7f7f4b87ff9c97350d89f5ff0de9adedc";
  };

  checkInputs = [ nose psutil ] ++
    lib.optionals isPy27 [ contextlib2 mock unittest2 ];
  propagatedBuildInputs = [ six ] ++
    lib.optionals (pythonOlder "3.4") [ statistics ];

  # tests not included in pypi repository
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m nose
  '';

  meta = with lib; {
    description = "Python module to generate and modify perf";
    homepage = "https://pyperf.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
