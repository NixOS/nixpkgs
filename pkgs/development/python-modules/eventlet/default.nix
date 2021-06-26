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
  version = "0.31.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b36ec2ecc003de87fc87b93197d77fea528aa0f9204a34fdf3b2f8d0f01e017b";
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
