{ lib, buildPythonPackage, fetchPypi, django-gravatar2, django-compressor
, django-allauth, mailmanclient, django, mock
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C3ZyiQZ50JFg2e+HS0oIJFK+dV8TcDYehVh875zBRFU=";
  };

  propagatedBuildInputs = [
    django-gravatar2 django-compressor django-allauth mailmanclient
  ];
  nativeCheckInputs = [ django mock ];

  checkPhase = ''
    cd $NIX_BUILD_TOP/$sourceRoot
    PYTHONPATH=.:$PYTHONPATH django-admin.py test --settings=django_mailman3.tests.settings_test
  '';

  pythonImportsCheck = [ "django_mailman3" ];

  meta = with lib; {
    description = "Django library for Mailman UIs";
    homepage = "https://gitlab.com/mailman/django-mailman3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ globin qyliss ];
  };
}
