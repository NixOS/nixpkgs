{
  lib,
  buildPythonPackage,
  fetchPypi,
  attrs,
  jsonpickle,
  pbr,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jschema-to-python";
  version = "1.2.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "jschema_to_python";
    inherit version;
    hash = "sha256-dv8U/l0wRwjMrRKE5LEflqZYlJox7n+u2eCZUnlUm5E=";
  };

  propagatedBuildInputs = [
    attrs
    jsonpickle
    pbr
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jschema_to_python" ];

  meta = with lib; {
    description = "Generate source code for Python classes from a JSON schema";
    homepage = "https://github.com/microsoft/jschema-to-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
