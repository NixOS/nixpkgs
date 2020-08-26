{ lib, buildPythonPackage, fetchPypi,
  flask, six, marshmallow
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "0.12.0";

  meta = {
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    description = "Flask + marshmallow for beautiful APIs";
    license = lib.licenses.mit;
  }; 

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e6aec171b8e092e0eafaf035ff5b8637bf3a58ab46f568c4c1bab02f2a3c196";
  };

  propagatedBuildInputs = [ flask marshmallow ];
  buildInputs = [ six ];

  doCheck = false;
}
