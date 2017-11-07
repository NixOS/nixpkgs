{ stdenv, buildPythonPackage, fetchurl, django }:
buildPythonPackage rec {
  version = "3.7.1";
  pname = "djangorestframework";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/djangorestframework/${name}.tar.gz";
    sha256 = "305b2c6564ca46d3b558ba21110ed717135c467adf1a6dfd192bd85f4bb04d50";
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
