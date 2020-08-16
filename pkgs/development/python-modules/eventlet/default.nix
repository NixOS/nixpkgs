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
  version = "0.26.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f4a43366b4cbd4a3f2f231816e5c3dae8ab316df9b7da11f0525e2800559f33";
  };

  checkInputs = [ nose ];

  doCheck = false;  # too much transient errors to bother

  propagatedBuildInputs = [ dnspython greenlet monotonic six ] ++ lib.optional (pythonOlder "3.4") enum34;

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/eventlet/";
    description = "A concurrent networking library for Python";
  };

}
