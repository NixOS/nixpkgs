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
  version = "0.16.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1ab4e5adfbc28681ce44b3024421c4f567e705cc3963c732bf1cba3348307de";
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
