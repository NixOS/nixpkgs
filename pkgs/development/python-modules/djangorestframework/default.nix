{ stdenv, buildPythonPackage, fetchPypi, django }:
buildPythonPackage rec {
  version = "3.9.1";
  pname = "djangorestframework";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79c6efbb2514bc50cf25906d7c0a5cfead714c7af667ff4bd110312cd380ae66";
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
