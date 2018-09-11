{ stdenv
, buildPythonPackage
, fetchPypi
, dnspython
, pyopenssl
, enum34
, greenlet
, monotonic
, six
, isPyPy
, pythonOlder
, pkgs
, nose
, httplib2
, pyzmq
, psycopg2
}:

buildPythonPackage rec {
  pname = "eventlet";
  version = "0.24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9d31a3c8dbcedbcce5859a919956d934685b17323fc80e1077cb344a2ffa68d";
  };

  # too many transient errors to bother (23 fails  / 300)
  doCheck = false;

  checkInputs = [ nose ];
  propagatedBuildInputs = [ dnspython monotonic six ]
      ++ stdenv.lib.optionals (!isPyPy) [ greenlet ]
      ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ];

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/eventlet/;
    license = licenses.mit;
    description = "A concurrent networking library for Python";
    maintainers = [ maintainers.costrouc ];
  };
}
