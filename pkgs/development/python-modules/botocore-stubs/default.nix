{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
, types-awscrt
, typing-extensions
}:

buildPythonPackage rec {
  pname = "botocore-stubs";
  version = "1.34.67";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "botocore_stubs";
    inherit version;
    hash = "sha256-ventoBzkmDwt3pQ68lRo6lb2dxUapTOqo5du41xuN7c=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    types-awscrt
    typing-extensions
  ];

  pythonImportsCheck = [
    "botocore-stubs"
  ];

  meta = with lib; {
    description = "Type annotations and code completion for botocore";
    homepage = "https://pypi.org/project/botocore-stubs/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
