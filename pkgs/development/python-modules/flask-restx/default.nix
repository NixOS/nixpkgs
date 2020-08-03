{ buildPythonPackage
, fetchPypi
, jsonschema
, flask
, six
, aniso8601
, pytz
, isPy27
, enum34
, lib
}:

buildPythonPackage rec {
  pname = "flask-restx";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19gjlb27x1wn77gmkma0p6j7jf6dwr20nx55a1dfrx1khf0a31ya";
  };

  propagatedBuildInputs = [
    aniso8601
    jsonschema
    flask
    six
    pytz
  ] ++ lib.optional isPy27 enum34;

  doCheck = false;

  meta = {
    homepage = "https://github.com/python-restx/flask-restx";
    description = "Flask-RESTX is an extension for Flask that adds support for quickly building REST APIs";
    license = lib.licenses.bsd3;
  };

}
