{ stdenv, buildPythonPackage, fetchurl, django }:
buildPythonPackage rec {
  version = "3.6.3";
  pname = "djangorestframework";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/djangorestframework/${name}.tar.gz";
    sha256 = "6aa6aafdfb7f6152a401873ecae93aff9eb54d7a74266065347cf4de68278ae4";
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
