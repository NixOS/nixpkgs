{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  python,
  django,
  packaging,
  nodejs,
  six,
}:

buildPythonPackage rec {
  pname = "django-js-reverse";
  version = "0.10.1-b1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "BITSOLVER";
    repo = "django-js-reverse";
    rev = version;
    hash = "sha256-i78UsxVwxyDAc8LrOVEXLG0tdidoQhvUx7GvPDaH0KY=";
  };

  propagatedBuildInputs = [ django ] ++ lib.optionals (pythonAtLeast "3.7") [ packaging ];

  # Js2py is needed for tests but it's unmaintained and insecure
  doCheck = false;

  nativeCheckInputs = [
    nodejs
    six
  ];

  checkPhase = ''
    ${python.interpreter} django_js_reverse/tests/unit_tests.py
  '';

  pythonImportsCheck = [ "django_js_reverse" ];

  meta = with lib; {
    description = "Javascript url handling for Django that doesn't hurt";
    homepage = "https://django-js-reverse.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
