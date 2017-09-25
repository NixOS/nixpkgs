{ stdenv, buildPythonPackage, fetchurl, django }:
buildPythonPackage rec {
  version = "3.6.4";
  pname = "djangorestframework";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/djangorestframework/${name}.tar.gz";
    sha256 = "de8ac68b3cf6dd41b98e01dcc92dc0022a5958f096eafc181a17fa975d18ca42";
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
