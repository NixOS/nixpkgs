{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-awscrt,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "botocore-stubs";
  version = "1.42.7";
  pyproject = true;

  src = fetchPypi {
    pname = "botocore_stubs";
    inherit version;
    hash = "sha256-lR/EHnjhpTtJv+hRG8JOQw7aTGicpgM8ZDaT5WSF5pw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    types-awscrt
    typing-extensions
  ];

  pythonImportsCheck = [ "botocore-stubs" ];

  meta = {
    description = "Type annotations and code completion for botocore";
    homepage = "https://pypi.org/project/botocore-stubs/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
