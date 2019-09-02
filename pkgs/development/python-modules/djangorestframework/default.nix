{ stdenv, buildPythonPackage, fetchPypi, django }:
buildPythonPackage rec {
  version = "3.9.4";
  pname = "djangorestframework";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c12869cfd83c33d579b17b3cb28a2ae7322a53c3ce85580c2a2ebe4e3f56c4fb";
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
