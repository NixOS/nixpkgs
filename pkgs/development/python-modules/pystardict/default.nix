{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pystardict";
  version = "0.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lig";
    repo = "pystardict";
    rev = version;
    hash = "sha256-YrZpIhyxfA3G7rP0SJ+EvzGwAXlne80AYilkj6cIDnA=";
  };

  propagatedBuildInputs = [ six ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pystardict" ];

  meta = with lib; {
    description = "Library for manipulating StarDict dictionaries from within Python";
    homepage = "https://github.com/lig/pystardict";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ thornycrackers ];
  };
}
