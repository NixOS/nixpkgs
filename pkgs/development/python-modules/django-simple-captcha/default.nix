{ stdenv, fetchurl, python, buildPythonPackage, six, testfixtures,
django, django-ranged-response, pillow }:

buildPythonPackage rec {
  pname = "django-simple-captcha";
  version = "0.5.11";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/86/d4/5baf10bfc9eb7844872c256898a405e81f22f7213e008ec90875689f913d/django-simple-captcha-0.5.11.zip";
    sha256 = "0zws9my33ayrxpprxw4k68mimpj8ganff28343xxzqvv415mqkp1";
  };

  checkInputs = [ testfixtures ];
  checkPhase = ''
    cd testproject
    ${python.interpreter} manage.py test captcha
  '';

  propagatedBuildInputs = [ django django-ranged-response six pillow ];

  meta = with stdenv.lib; {
    description = "An extremely simple, yet highly customizable Django application to add captcha images to any Django form";
    homepage = "https://github.com/mbi/django-simple-captcha";
    license = licenses.mit;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
