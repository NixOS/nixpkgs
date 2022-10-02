{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "5.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rLYA+EghRzEqJ71Y5jdmqgODMQGB5IXm6qL0LSZQLJs=";
  };

  # tests assume the availability of a mysql/postgresql database
  doCheck = false;

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [ "reversion" ];

  meta = with lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
