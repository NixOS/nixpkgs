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
  version = "0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15bq5ybbigxnp5xwkps53zyhlg15lmcnq3ny2dppj0r0bylcs5rf";
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
