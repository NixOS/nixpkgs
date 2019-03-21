{ lib, buildPythonPackage, fetchPypi,
  flask, six, marshmallow
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "0.9.0";

  meta = {
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    description = "Flask + marshmallow for beautiful APIs";
    license = lib.licenses.mit;
  }; 

  src = fetchPypi {
    inherit pname version;
    sha256 = "db7aff4130eb99fd05ab78fd2e2c58843ba0f208899aeb1c14aff9cd98ae8c80";
  };

  propagatedBuildInputs = [ flask marshmallow ];
  buildInputs = [ six ];

  doCheck = false;
}
