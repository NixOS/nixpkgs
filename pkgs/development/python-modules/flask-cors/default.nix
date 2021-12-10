{ lib, fetchFromGitHub, buildPythonPackage
, nose, flask, six, packaging }:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "3.0.10";

  src = fetchFromGitHub {
     owner = "corydolphin";
     repo = "flask-cors";
     rev = "3.0.10";
     sha256 = "1q8l56wfwjj5vzr6j4lq2s90f8qj7vlk5913437s85b56gghkmdz";
  };

  checkInputs = [ nose packaging ];
  propagatedBuildInputs = [ flask six ];

  # Exclude test_acl_uncaught_exception_500 test case because is not compatible
  # with Flask>=1.1.0. See: https://github.com/corydolphin/flask-cors/issues/253
  checkPhase = ''
    nosetests --exclude test_acl_uncaught_exception_500
  '';

  meta = with lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = "https://github.com/corydolphin/flask-cors";
    license = with licenses; [ mit ];
  };
}
