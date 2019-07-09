{ stdenv, buildPythonPackage, fetchFromGitHub, python, six, testfixtures,
django, django-ranged-response, pillow }:

buildPythonPackage rec {
  pname = "django-simple-captcha";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-simple-captcha";
    rev = "v${version}";
    sha256 = "0wdfhag3ybvsmxyklly0fi0p5zbi6bf46z9si64glgk3nq3ipg7z";
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
