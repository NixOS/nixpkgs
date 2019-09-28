{ stdenv, buildPythonPackage, fetchPypi, django }:
buildPythonPackage rec {
  version = "3.10.2";
  pname = "djangorestframework";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nd3i57w44115a2hkjdgh90ynj287gyza7dbm98rdaxz1q0linxf";
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
