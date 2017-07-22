{ stdenv, buildPythonPackage, fetchFromGitHub
, vobject, mock, tox, pytestcov, pytest-django, pytest, shortuuid
, django, six
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "1.8.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "${pname}";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "08rd9zswvjb9dixzyd3p3l3hw3wwhqkgyjvid65niybzjl1xdb5h";
  };

  buildInputs = [ vobject mock tox pytestcov pytest-django pytest shortuuid ];

  propagatedBuildInputs = [ django six ];

  meta = with stdenv.lib; {
    description = "A collection of custom extensions for the Django Framework";
    homepage = https://github.com/django-extensions/django-extensions;
    licenses = [ licenses.mit ];
  };
}
