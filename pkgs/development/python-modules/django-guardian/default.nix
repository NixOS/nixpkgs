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
    sha256 = "c58a68ae76922d33e6bdc0e69af1892097838de56e93e78a8361090bcd9f89a0";
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
    maintainers = [ ];
  };
}
