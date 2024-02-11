{ lib
, buildPythonPackage
, django
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "django-stubs-ext";
  version = "4.2.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UZNCrAhJzaFVl0bJpWPwP/mfY2sOvnwUt16BagDf3cM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    django
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "django_stubs_ext"
  ];

  meta = with lib; {
    description = "Extensions and monkey-patching for django-stubs";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
