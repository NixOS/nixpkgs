{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-wtf
, mongoengine
, six
, email-validator
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flask-mongoengine";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "v${version}";
    sha256 = "10g9b13ls2msnhv8j44gslrfxa2ppqz2y1xjn2a4gg4m9mdjv8b2";
  };

  propagatedBuildInputs = [
    email-validator
    flask
    flask-wtf
    mongoengine
    six
  ];

  # Tests require working mongodb connection
  doCheck = false;

  pythonImportsCheck = [
    "flask_mongoengine"
  ];

  meta = with lib; {
    description = "Flask extension that provides integration with MongoEngine and WTF model forms";
    homepage = "https://github.com/mongoengine/flask-mongoengine";
    changelog = "https://github.com/MongoEngine/flask-mongoengine/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
