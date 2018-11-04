{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, httplib2
, pyopenssl
, greenlet
, enum-compat
, isPyPy
}:

buildPythonPackage rec {
  pname = "eventlet";
  version = "0.24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9d31a3c8dbcedbcce5859a919956d934685b17323fc80e1077cb344a2ffa68d";
  };

  buildInputs = [ nose httplib2 pyopenssl ];

  doCheck = false;  # too much transient errors to bother

  propagatedBuildInputs = [ enum-compat ]
    ++ stdenv.lib.optionals (!isPyPy) [ greenlet ];

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/eventlet/;
    description = "A concurrent networking library for Python";
  };

}
