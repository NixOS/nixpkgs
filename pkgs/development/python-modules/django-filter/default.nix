{ lib
, fetchPypi
, django
, buildPythonPackage
}:
buildPythonPackage rec {

  pname = "django-filter";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3dafb7d2810790498895c22a1f31b2375795910680ac9c1432821cbedb1e176d";
  };

  doCheck = false;
  propagatedBuildInputs = [
    django
  ];

  meta = with lib; {
    homepage = "https://github.com/carltongibson/django-filter/tree/master";
    license = licenses.bsdOriginal;
    description = "Django-filter is a reusable Django application for allowing users to filter querysets dynamically.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
