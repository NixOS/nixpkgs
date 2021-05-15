{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-contrib-comments";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d82f1d04690550df026553053903deec0c52dc54212e1b79241b08f0355cff2c";
  };

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    homepage = "https://github.com/django/django-contrib-comments";
    description = "The code formerly known as django.contrib.comments";
    license = licenses.bsd0;
  };

}
