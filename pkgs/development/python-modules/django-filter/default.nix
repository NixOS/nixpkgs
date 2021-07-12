{ lib
, buildPythonPackage
, fetchPypi
, django
, djangorestframework, python, mock
}:

buildPythonPackage rec {
  pname = "django-filter";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84e9d5bb93f237e451db814ed422a3a625751cbc9968b484ecc74964a8696b06";
  };

  propagatedBuildInputs = [ django ];

  # Tests fail (needs the 'crispy_forms' module not packaged on nixos)
  doCheck = false;
  checkInputs = [ djangorestframework django mock ];
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
