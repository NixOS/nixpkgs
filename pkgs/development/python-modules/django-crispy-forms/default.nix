{ stdenv, buildPythonPackage, fetchPypi, pytest-django, pytest }:

buildPythonPackage rec {
  pname = "django-crispy-forms";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pv7y648i8iz7mf64gkjizpbx5d01ap2s4vqqa30n38if6wvlljr";
  };

  checkInputs = [
    pytest pytest-django
  ];

  # see Makefile
  checkPhase = ''
    DJANGO_SETTINGS_MODULE=crispy_forms.tests.test_settings py.test crispy_forms/tests
  '';

  # ???: Tests are trying to access the build directory using the sandbox-external path
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Web APIs for Django, made easy";
    homepage = http://www.django-rest-framework.org/;
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
