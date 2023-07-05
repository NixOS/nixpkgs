{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-context-decorator";
  version = "1.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rixx";
    repo = "django-context-decorator";
    rev = "v${version}";
    hash = "sha256-/FDGWGC1Pdu+RLyazDNZv+CMf5vscXprLdN8ELjUFNo=";
  };

  pythonImportsCheck = [
    "django_context_decorator"
  ];

  nativeCheckInputs = [
    django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Django @context decorator";
    homepage = "https://github.com/rixx/django-context-decorator";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
