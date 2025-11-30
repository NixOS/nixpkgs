{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  nodejs,
  packaging,
  python,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "django-js-reverse";
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vintasoftware";
    repo = "django-js-reverse";
    tag = "v${version}";
    hash = "sha256-0S1g8tLWaJVV2QGPeiBOevhz9f0ueINxA9HOcnXuyYg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    packaging
  ];

  nativeCheckInputs = [
    nodejs
    six
  ];

  # Js2py is needed for tests but it's unmaintained and insecure
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} django_js_reverse/tests/unit_tests.py
  '';

  pythonImportsCheck = [ "django_js_reverse" ];

  meta = with lib; {
    description = "Javascript URL handling for Django";
    homepage = "https://django-js-reverse.readthedocs.io/";
    changelog = "https://github.com/vintasoftware/django-js-reverse/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
