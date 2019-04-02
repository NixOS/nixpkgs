{ lib, buildPythonPackage, fetchPypi,
  flask, six, marshmallow
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "0.10.0";

  meta = {
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    description = "Flask + marshmallow for beautiful APIs";
    license = lib.licenses.mit;
  }; 

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xvk289628l3pp56gidwhmd54cgdczpsxhxfw0bfcsd120k1svfv";
  };

  propagatedBuildInputs = [ flask marshmallow ];
  buildInputs = [ six ];

  doCheck = false;
}
