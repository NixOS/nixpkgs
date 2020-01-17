{ stdenv, buildPythonPackage, fetchPypi, django, isPy27 }:

buildPythonPackage rec {
  version = "3.11.0";
  pname = "djangorestframework";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e782087823c47a26826ee5b6fa0c542968219263fb3976ec3c31edab23a4001f";
  };

  # Test settings are missing
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Web APIs for Django, made easy";
    homepage = https://www.django-rest-framework.org/;
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
