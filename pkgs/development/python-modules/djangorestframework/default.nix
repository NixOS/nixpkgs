{ stdenv, buildPythonPackage, fetchurl, django }:
buildPythonPackage rec {
  version = "3.8.0";
  pname = "djangorestframework";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/djangorestframework/${name}.tar.gz";
    sha256 = "be299fb3f289e22ddca0ff88294924cd06aa3bcfa5043f72792d2a18d96dabe8";
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
