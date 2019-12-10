{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-contrib-comments";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1232bade3094de07dcc205fc833204384e71ba9d30caadcb5bb2882ce8e8d31";
  };

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    homepage = https://github.com/django/django-contrib-comments;
    description = "The code formerly known as django.contrib.comments";
    license = licenses.bsd0;
  };

}
