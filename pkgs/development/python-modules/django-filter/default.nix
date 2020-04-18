{ stdenv
, buildPythonPackage
, fetchPypi
, django
, djangorestframework, python, mock
}:

buildPythonPackage rec {
  pname = "django-filter";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "057xiijig8r2nxrd9gj1nki168422rsh8ap5vkbr9zyp1mzvbpn3";
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
