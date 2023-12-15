{ lib
, buildPythonPackage
, django
, fetchPypi
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "django-stubs-ext";
  version = "4.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jE0ftfaEGbOyR0xlloGhiYA+J9al5av1qg2ldgG1hjM=";
  };

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
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
