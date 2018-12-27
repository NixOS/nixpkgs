{ stdenv, buildPythonPackage, fetchPypi, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "3.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "133s9js7j1b2m6vv56a2xd9in0rmx5zrdp4r005qwbvr5qxld39s";
  };

  propagatedBuildInputs = [ flask pyjwt werkzeug ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with stdenv.lib; {
    description = "JWT extension for Flask";
    homepage = https://flask-jwt-extended.readthedocs.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
  };
}
