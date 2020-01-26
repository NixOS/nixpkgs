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
  version = "0.5.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:1g92sdgcb81r3il34pg0z210cz6wm14k00b558nshai8br1g09gw";
    extension = "zip";
  };

  checkInputs = [ testfixtures ];
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
