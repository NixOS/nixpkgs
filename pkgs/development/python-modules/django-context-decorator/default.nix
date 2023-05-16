{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-context-decorator";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rixx";
    repo = "django-context-decorator";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/FDGWGC1Pdu+RLyazDNZv+CMf5vscXprLdN8ELjUFNo=";
=======
    hash = "sha256-wgVZadI+4gK9snLfy/9FgFJJHqMyxndcxXwqIkMH29k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
