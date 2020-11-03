{ lib, buildPythonPackage, fetchPypi,
  flask, six, marshmallow
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "0.13.0";

  meta = {
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    description = "Flask + marshmallow for beautiful APIs";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "aefc1f1d96256c430a409f08241bab75ffe97e5d14ac5d1f000764e39bf4873a";
  };

  requiredPythonModules = [ flask marshmallow ];
  buildInputs = [ six ];

  doCheck = false;
}
