{ lib
, buildPythonPackage
, fetchPypi
, python
, testfixtures
, django
, django-ranged-response
, pillow
, withTTS ? true
, flite
}:

buildPythonPackage rec {
  pname = "django-simple-captcha";
  version = "0.5.17";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lknmbatOce+sv+8C9IuDuRaEiYNSoatW8Whs5xAzsyg=";
  };

  nativeCheckInputs = [
    testfixtures
  ];

  checkPhase = ''
    cd testproject
    ${python.interpreter} manage.py test captcha
  '';

  propagatedBuildInputs = [
    django
    django-ranged-response
    pillow
  ] ++ lib.optional withTTS flite;

  meta = with lib; {
    description = "Customizable Django application to add captcha images to any Django form";
    homepage = "https://github.com/mbi/django-simple-captcha";
    changelog = "https://github.com/mbi/django-simple-captcha/blob/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ mrmebelman schmittlauch ];
  };
}
