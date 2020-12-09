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
  version = "0.29.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9faff63631b01277c463ae91cd4ab3f25a2f0f5abe3219d43a386ef1daa6159a";
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
