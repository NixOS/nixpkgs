{ buildPythonPackage, fetchPypi, lib, ujson, email_validator }:

buildPythonPackage rec {
  pname = "pydantic";
  version = "0.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13k8mysyrqp2jsd23sjv9r4lpkzrq2lbrnxkz36f3d56x421idsq";
  };

  buildInputs = [ ujson email_validator ];

  meta = with lib; {
    description = "Data validation and settings management using python type hinting";
    homepage = https://pydantic-docs.helpmanual.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
