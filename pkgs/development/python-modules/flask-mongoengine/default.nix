{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask_wtf
, mongoengine
, six
, nose
, rednose
, coverage
}:

buildPythonPackage rec {
  pname = "flask-mongoengine";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "v${version}";
    sha256 = "05hfddf1dm594wnjyqhj0zmjfsf1kpmx1frjwhypgzx4hf62qcmr";
  };

  propagatedBuildInputs = [
    flask
    flask_wtf
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
