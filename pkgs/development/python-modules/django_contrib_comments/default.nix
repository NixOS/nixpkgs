{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-contrib-comments";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61b051d7bc3ff593e86b41a1ed5e969423cf55cc92768598af3315e2528e0890";
  };

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    homepage = https://github.com/django/django-contrib-comments;
    description = "The code formerly known as django.contrib.comments";
    license = licenses.bsd0;
  };

}
