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
  pname = "perf";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5aae76e58bd3edd0c50adcc7c16926ebb9ed8c0e5058b435a30d58c6bb0394a8";
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
    homepage = https://github.com/vstinner/perf;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
