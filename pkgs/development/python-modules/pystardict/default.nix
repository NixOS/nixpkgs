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
  version = "0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lig";
    repo = "pystardict";
    tag = "v${version}";
    hash = "sha256-VWOxggAKifN5f6nSN1xsSbg0hpKzrHDw+UqnAOzsXj0=";
  };

  propagatedBuildInputs = [ six ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pystardict" ];

  meta = {
    description = "Library for manipulating StarDict dictionaries from within Python";
    homepage = "https://github.com/lig/pystardict";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ thornycrackers ];
  };
}
