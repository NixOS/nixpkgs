{ stdenv, buildPythonPackage, fetchPypi, django, isPy27 }:

buildPythonPackage rec {
  version = "3.11.2";
  pname = "djangorestframework";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5967b68a04e0d97d10f4df228e30f5a2d82ba63b9d03e1759f84993b7bf1b53";
  };

  # Test settings are missing
  doCheck = false;

  requiredPythonModules = [ django ];

  meta = with stdenv.lib; {
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
