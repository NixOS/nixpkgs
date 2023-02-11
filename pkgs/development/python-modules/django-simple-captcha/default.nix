{ lib
, buildPythonPackage
, fetchPypi
, python
, six
, testfixtures
, django
, django-ranged-response
, pillow
, withTTS ? true
, flite
}:

buildPythonPackage rec {
  pname = "django-simple-captcha";
  version = "0.5.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84b5c188e6ae50e9ecec5e5d734c5bc4d2a50fbbca7f59d2c12da9a3bbee5051";
    extension = "zip";
  };

  nativeCheckInputs = [ testfixtures ];
  checkPhase = ''
    cd testproject
    ${python.interpreter} manage.py test captcha
  '';

  propagatedBuildInputs = [ django django-ranged-response six pillow ]
  ++ lib.optional withTTS flite;

  meta = with lib; {
    description = "An extremely simple, yet highly customizable Django application to add captcha images to any Django form";
    homepage = "https://github.com/mbi/django-simple-captcha";
    license = licenses.mit;
    maintainers = with maintainers; [ mrmebelman schmittlauch ];
  };
}
