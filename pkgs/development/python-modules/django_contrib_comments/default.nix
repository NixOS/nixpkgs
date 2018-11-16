{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-contrib-comments";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "689f3f80ff7ea8ab9f712ae5fe17ffa2ee8babbf8d75229ee8acc7bad461dfef";
  };

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    homepage = https://github.com/django/django-contrib-comments;
    description = "The code formerly known as django.contrib.comments";
    license = licenses.bsd0;
  };

}
