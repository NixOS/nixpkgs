{ lib, buildPythonPackage, fetchPypi
, attrs
, jsonpickle
, pbr
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jschema-to-python";
  version = "1.2.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "jschema_to_python";
    inherit version;
    sha256 = "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91";
  };

  propagatedBuildInputs = [
    attrs
    jsonpickle
    pbr
  ];

  nativeCheckInputs =[
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jschema_to_python" ];

  meta = with lib; {
    description = "Generate source code for Python classes from a JSON schema";
    homepage = "https://github.com/microsoft/jschema-to-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
