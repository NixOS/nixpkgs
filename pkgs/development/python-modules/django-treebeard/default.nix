{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-treebeard";
  version = "4.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YbgHa1dhB9oh9vYEB3TA0XAlIAwu/bcN0fFLGMkgbDo=";
  };

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "treebeard" ];

  meta = {
    description = "Efficient tree implementations for Django";
    homepage = "https://tabo.pe/projects/django-treebeard/";
    changelog = "https://github.com/django-treebeard/django-treebeard/blob/${version}/CHANGES.md";
    license = lib.licenses.asl20;
  };
}
