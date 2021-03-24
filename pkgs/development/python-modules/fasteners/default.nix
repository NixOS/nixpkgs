{ lib
, buildPythonPackage
, fetchPypi
, six
, monotonic
, diskcache
, more-itertools
, testtools
, isPy3k
, nose
, futures ? null
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c995d8c26b017c5d6a6de9ad29a0f9cdd57de61ae1113d28fac26622b06a0933";
  };

  propagatedBuildInputs = [
    six
    monotonic
  ];

  checkInputs = [
    diskcache
    more-itertools
    testtools
    nose
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "A python package that provides useful locks";
    homepage = "https://github.com/harlowja/fasteners";
    license = licenses.asl20;
  };

}
