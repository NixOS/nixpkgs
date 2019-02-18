{ stdenv, buildPythonPackage, fetchFromGitHub, python, django, dj-database-url }:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "2.0.3";

  # PyPI tarball is missing some test files
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "08qk3rbk0xlphwalkigbhqpmfaqjk1sxmlfh8zy8s8dw7fw1myk4";
  };

  checkInputs = [ dj-database-url ];
  propagatedBuildInputs = [ django ];

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = {
    homepage = https://github.com/django-polymorphic/django-polymorphic;
    description = "Improved Django model inheritance with automatic downcasting";
    license = stdenv.lib.licenses.bsd3;
  };
}
