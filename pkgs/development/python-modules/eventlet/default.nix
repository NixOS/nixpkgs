{ lib, buildPythonPackage, fetchPypi
, isPyPy
, coverage
, greenlet, enum-compat
, nose, httplib2, pyopenssl, pyzmq
}:

buildPythonPackage rec {
  pname = "eventlet";
  version = "0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15bq5ybbigxnp5xwkps53zyhlg15lmcnq3ny2dppj0r0bylcs5rf";
  };

  # Too many transient errors
  doCheck = false;
  checkInputs = [ coverage nose httplib2 pyopenssl pyzmq ];

  propagatedBuildInputs = [ enum-compat ] ++ lib.optional (!isPyPy) greenlet ;

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/eventlet/;
    description = "A concurrent networking library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
