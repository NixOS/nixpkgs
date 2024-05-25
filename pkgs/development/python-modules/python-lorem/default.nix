{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  version = "1.3.0.post1";
  pname = "python-lorem";
  disabled = pythonOlder "3.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aokLCuQq6iHpC90MLCcIQxeEArPyx1o6RU1224xZdxY=";
  };

  buildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "lorem"
  ];

  meta = with lib; {
    description = "Pythonic lorem ipsum generator";
    homepage = "https://github.com/JarryShaw/lorem";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aleksana ];
  };
}
