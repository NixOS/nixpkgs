{ stdenv, buildPythonPackage, fetchurl, django }:
buildPythonPackage rec {
  name = "djangorestframework-${version}";
  version = "3.5.4";

  src = fetchurl {
    url = "mirror://pypi/d/djangorestframework/${name}.tar.gz";
    sha256 = "1rays9d8jxqng13fv18ldf11y44w0ln6vvj2k8m4sd9gw9da75gr";
  };

  # Test settings are missing
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Web APIs for Django, made easy";
    homepage = http://www.django-rest-framework.org/;
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
