{ stdenv
, buildPythonPackage
, fetchPypi
, django
, djangorestframework, python, mock
}:

buildPythonPackage rec {
  pname = "django-filter";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11e63dd759835d9ba7a763926ffb2662cf8a6dcb4c7971a95064de34dbc7e5af";
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

  meta = with stdenv.lib; {
    description = "Reusable Django application for allowing users to filter querysets dynamically";
    homepage = "https://pypi.org/project/django-filter/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
