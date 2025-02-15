{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  types-awscrt,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "botocore-stubs";
  version = "1.36.18";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "botocore_stubs";
    inherit version;
    hash = "sha256-bSGy/fN1+rJcQD/uY+4xsC+nIlNwnOBkYJM6hpFg/TI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    types-awscrt
    typing-extensions
  ];

  pythonImportsCheck = [ "botocore-stubs" ];

  meta = with lib; {
    description = "Type annotations and code completion for botocore";
    homepage = "https://pypi.org/project/botocore-stubs/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
