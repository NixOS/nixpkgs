{ lib
, buildPythonPackage
, fetchPypi
, django
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "5.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

src = fetchPypi {
    inherit pname version;
    hash = "sha256-rLYA+EghRzEqJ71Y5jdmqgODMQGB5IXm6qL0LSZQLJs=";
  };

  propagatedBuildInputs = [
    django
  ];

  # Tests assume the availability of a mysql/postgresql database
  doCheck = false;

  pythonImportsCheck = [
    "reversion"
  ];

  meta = with lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
