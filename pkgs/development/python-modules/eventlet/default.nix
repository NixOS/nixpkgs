{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, dnspython
, enum34
, greenlet
, monotonic
, six
, nose
}:

buildPythonPackage rec {
  pname = "eventlet";
  version = "0.25.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c8ab42c51bff55204fef43cff32616558bedbc7538d876bb6a96ce820c7f9ed";
  };

  checkInputs = [ nose ];

  doCheck = false;  # too much transient errors to bother

  propagatedBuildInputs = [ dnspython greenlet monotonic six ] ++ lib.optional (pythonOlder "3.4") enum34;

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/eventlet/";
    description = "A concurrent networking library for Python";
  };

}
