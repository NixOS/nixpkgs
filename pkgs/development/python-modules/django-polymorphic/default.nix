{ lib, buildPythonPackage, fetchFromGitHub, python, django, dj-database-url }:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "2.1.2";

  # PyPI tarball is missing some test files
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0zghrq7y7g2ls38cz6y98qj5xwnn992slhb95qyp6l66d420j179";
  };

  checkInputs = [ dj-database-url ];
  propagatedBuildInputs = [ django ];

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = with lib; {
    homepage = "https://github.com/django-polymorphic/django-polymorphic";
    description = "Improved Django model inheritance with automatic downcasting";
    license = licenses.bsd3;
  };
}
