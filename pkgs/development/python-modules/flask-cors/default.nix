{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six }:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "3.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05id72xwvhni23yasdvpdd8vsf3v4j6gzbqqff2g04j6xcih85vj";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ flask six ];

  # Exclude test_acl_uncaught_exception_500 test case because is not compatible
  # with Flask>=1.1.0. See: https://github.com/corydolphin/flask-cors/issues/253
  checkPhase = ''
    nosetests --exclude test_acl_uncaught_exception_500
  '';

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = https://github.com/corydolphin/flask-cors;
    license = with licenses; [ mit ];
  };
}
