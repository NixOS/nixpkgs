{
  lib,
  buildPythonPackage,
  fetchPypi,
  django-environ,
  mock,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-guardian";
  version = "2.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xYpornaSLTPmvcDmmvGJIJeDjeVuk+eKg2EJC82fiaA=";
  };

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [
    django-environ
    mock
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "guardian" ];

  meta = with lib; {
    description = "Per object permissions for Django";
    homepage = "https://github.com/django-guardian/django-guardian";
    license = with licenses; [
      mit
      bsd2
    ];
    maintainers = with maintainers; [ ];
  };
}
