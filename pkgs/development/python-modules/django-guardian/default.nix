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
  version = "3.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TlnqtNg22loCfPDBdtFLwqTiLLvfdTFZoDlGwIyKGW0=";
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
