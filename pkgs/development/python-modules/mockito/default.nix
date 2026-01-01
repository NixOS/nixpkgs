{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  numpy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mockito";
  version = "1.5.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SYJuOQHcgm0CBOk7Ftzhxh3enTqU6tycIJqw4TAoM5M=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mockito" ];

<<<<<<< HEAD
  meta = {
    description = "Spying framework";
    homepage = "https://github.com/kaste/mockito-python";
    changelog = "https://github.com/kaste/mockito-python/blob/${version}/CHANGES.txt";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Spying framework";
    homepage = "https://github.com/kaste/mockito-python";
    changelog = "https://github.com/kaste/mockito-python/blob/${version}/CHANGES.txt";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
