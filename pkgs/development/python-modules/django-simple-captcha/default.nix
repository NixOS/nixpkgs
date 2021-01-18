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
  version = "0.5.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e43ba3b61daf690ac0319157837bb57e31df8bddbdc9a59ef42ef1a99e21fa2";
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
