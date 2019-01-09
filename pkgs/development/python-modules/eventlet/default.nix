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
  version = "0.24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9d31a3c8dbcedbcce5859a919956d934685b17323fc80e1077cb344a2ffa68d";
  };

  checkInputs = [ nose ];

  doCheck = false;  # too much transient errors to bother

  propagatedBuildInputs = [ dnspython greenlet monotonic six ] ++ lib.optional (pythonOlder "3.4") enum34;

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/eventlet/;
    description = "A concurrent networking library for Python";
  };

}
