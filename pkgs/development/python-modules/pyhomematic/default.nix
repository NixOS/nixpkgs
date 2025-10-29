{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.78";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uB9aDa1urIwL2DBdBwPi0sHWPW7SUZ3EaAjuMLSOudc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyhomematic" ];

  meta = with lib; {
    description = "Python 3 Interface to interact with Homematic devices";
    homepage = "https://github.com/danielperna84/pyhomematic";
    changelog = "https://github.com/danielperna84/pyhomematic/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
