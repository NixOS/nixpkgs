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
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1257d673d89fdcdbaec8077afeb365e7a94739c1b263572b09403cac25708ad3";
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
