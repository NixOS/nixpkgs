{ stdenv, buildPythonPackage, fetchurl, django }:
buildPythonPackage rec {
  version = "3.7.3";
  pname = "djangorestframework";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/djangorestframework/${name}.tar.gz";
    sha256 = "067960e5e9e5586d3b2d53a1d626c4800dc33cd8309487d404fc63355674556f";
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
