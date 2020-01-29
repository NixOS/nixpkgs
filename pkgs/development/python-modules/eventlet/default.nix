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
  version = "0.25.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c9c625af48424c4680d89314dbe45a76cc990cf002489f9469ff214b044ffc1";
  };

  checkInputs = [ nose ];

  doCheck = false;  # too much transient errors to bother

  propagatedBuildInputs = [ dnspython greenlet monotonic six ] ++ lib.optional (pythonOlder "3.4") enum34;

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/eventlet/;
    description = "A concurrent networking library for Python";
  };

}
