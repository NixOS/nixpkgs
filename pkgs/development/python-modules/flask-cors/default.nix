{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six, packaging }:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "3.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bcfc100288c5d1bcb1dbb854babd59beee622ffd321e444b05f24d6d58466b8";
  };

  checkInputs = [ nose packaging ];
  requiredPythonModules = [ flask six ];

  # Exclude test_acl_uncaught_exception_500 test case because is not compatible
  # with Flask>=1.1.0. See: https://github.com/corydolphin/flask-cors/issues/253
  checkPhase = ''
    nosetests --exclude test_acl_uncaught_exception_500
  '';

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = "https://github.com/corydolphin/flask-cors";
    license = with licenses; [ mit ];
  };
}
