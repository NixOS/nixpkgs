{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyroaring";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ezibenroc";
    repo = "PyRoaringBitMap";
    tag = version;
    hash = "sha256-of4BuTHtIIwdpWUm0d9CByWc8YiaxXNQ1oDXUZYWRjU=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "pyroaring" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    description = "Python library for handling efficiently sorted integer sets";
    homepage = "https://github.com/Ezibenroc/PyRoaringBitMap";
    changelog = "https://github.com/Ezibenroc/PyRoaringBitMap/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
