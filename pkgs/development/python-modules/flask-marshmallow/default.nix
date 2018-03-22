{ lib, buildPythonPackage, fetchPypi,
  flask, six, marshmallow
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  name = "${pname}-${version}";
  version = "0.8.0";

  meta = {
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    description = "Flask + marshmallow for beautiful APIs";
    license = lib.licenses.mit;
  }; 

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fa6xgxrn9bbc2pazbg46iw3ykvpcwib5b5s46qn59ndwj77lifi";
  };

  propagatedBuildInputs = [ flask marshmallow ];
  buildInputs = [ six ];

  doCheck = false;
}
