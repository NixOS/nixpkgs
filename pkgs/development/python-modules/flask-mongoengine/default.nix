{ stdenv
, buildPythonPackage
, python
, fetchPypi
, flask
, flask_wtf
, rednose
, six
, mongoengine
}:

buildPythonPackage rec {
  pname = "flask-mongoengine";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hcg2kz88ih2350pmfdkqjpvf4nh09fqn3sckdzc7qjbzkm6lhhg";
  };

  buildInputs = [
    flask
    flask_wtf
    rednose
    six
    mongoengine
  ];

  doCheck = false;

  propagatedBuildInputs = [
    flask
    mongoengine
  ];

  meta = with stdenv.lib; {
    description = "A Flask extension that provides integration with MongoEngine";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/mongoengine/flask-mongoengine;
  };
}
