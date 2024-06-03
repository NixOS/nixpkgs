{
  lib,
  fetchPypi,
  buildPythonPackage,
  django-classy-tags,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-sekizai";
  version = "4.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Kso2y64LXAzv7ZVlQW7EQjNXZ/sxRb/xHlhiL8ZTza0=";
  };

  propagatedBuildInputs = [ django-classy-tags ];

  checkInputs = [
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "sekizai" ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = with lib; {
    description = "Define placeholders where your blocks get rendered and append to those blocks";
    homepage = "https://github.com/django-cms/django-sekizai";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
