{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-wtf
, mongoengine
, six
, nose
, rednose
, coverage
, email-validator
}:

buildPythonPackage rec {
  pname = "flask-mongoengine";
  version = "1.0.0";

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

  # they set test requirements to setup_requirements...
  buildInputs = [
    nose
    rednose
    coverage
  ];

  # tests require working mongodb connection
  doCheck = false;

  meta = with lib; {
    description = "Flask-MongoEngine is a Flask extension that provides integration with MongoEngine and WTF model forms";
    homepage = "https://github.com/mongoengine/flask-mongoengine";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
