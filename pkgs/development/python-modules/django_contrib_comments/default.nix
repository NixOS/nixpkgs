{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-contrib-comments";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26350b2c353816570a74b7fb19c558ce00288625ac32886a5274f4f931c098f9";
  };

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    homepage = "https://github.com/django/django-contrib-comments";
    description = "The code formerly known as django.contrib.comments";
    license = licenses.bsd0;
  };

}
