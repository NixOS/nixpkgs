{ lib
, buildPythonPackage
, fetchPypi
, django
, djangorestframework, python, mock
}:

buildPythonPackage rec {
  pname = "django-filter";
  version = "21.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YyolH6jxqttLjM7/kyu1L+L4Jt19/n8+rEDlxGPWg24=";
  };

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [
    "django_filters"
  ];

  # Tests fail (needs the 'crispy_forms' module not packaged on nixos)
  doCheck = false;

  checkInputs = [
    djangorestframework
    django
    mock
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py tests
    runHook postCheck
  '';

  meta = with lib; {
    description = "Reusable Django application for allowing users to filter querysets dynamically";
    homepage = "https://pypi.org/project/django-filter/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
