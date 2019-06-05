{ stdenv
, buildPythonPackage
, fetchPypi
, six
, monotonic
, testtools
, isPy3k
, nose
, futures
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a176da6b70df9bb88498e1a18a9e4a8579ed5b9141207762368a1017bf8f5ef";
  };

  propagatedBuildInputs = [ six monotonic ];

  checkInputs = [ testtools nose ] ++ stdenv.lib.optionals (!isPy3k) [ futures ];

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "A python package that provides useful locks";
    homepage = https://github.com/harlowja/fasteners;
    license = licenses.asl20;
  };

}
