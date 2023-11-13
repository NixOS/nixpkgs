{ lib, fetchPypi, buildPythonPackage
, nose, flask, six, packaging }:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "3.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b60839393f3b84a0f3746f6cdca56c1ad7426aa738b70d6c61375857823181de";
  };

  nativeCheckInputs = [ nose packaging ];
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
