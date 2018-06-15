{ stdenv, buildPythonPackage, fetchFromGitHub, python, django, dj-database-url }:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "2.0.2";

  # PyPI tarball is missing some test files
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "18p84kdwpfp423vb2n38h840mj3bq0j57jx3cry7c8dznpi0vfi2";
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
