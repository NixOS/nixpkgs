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
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vrv83v8rhyl51yaxlqzw567vz5a9qwkymk3vqvcl5sa2yd3mzgp";
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
