{ stdenv
, buildPythonPackage
, fetchPypi
, flask
}:

buildPythonPackage rec {
  pname = "Flask-Silk";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gjzighx4f0w39sq9xvzr1kwb4y7yv9qrgzvli1p89gy16piz8l0";
  };

  propagatedBuildInputs = [
    flask
  ];

  meta = with stdenv.lib; {
    description = "Adds silk icons to your Flask application or module, or extension";
    license = licenses.bsd3;
    maintainers = with maintainers; [ timokau ];
    homepage = https://github.com/sublee/flask-silk;
  };
}
