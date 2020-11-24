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
  version = "0.28.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55eef68e39473d6a58d28c4cf388cb8b7d29bab76568e7124d7df98d9365ab35";
  };

  propagatedBuildInputs = [ dnspython greenlet monotonic six ]
    ++ lib.optional (pythonOlder "3.4") enum34;

  prePatch = ''
    substituteInPlace setup.py \
      --replace "dnspython >= 1.15.0, < 2.0.0" "dnspython"
  '';

  checkInputs = [ nose ];

  doCheck = false;  # too much transient errors to bother

  # unfortunately, it needs /etc/protocol to be present to not fail
  #pythonImportsCheck = [ "eventlet" ];

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/eventlet/";
    description = "A concurrent networking library for Python";
    license = licenses.mit;
  };

}
