{ lib, buildPythonPackage, fetchPypi, django-gravatar2, django-compressor
, django-allauth, mailmanclient, django, mock
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ea8c24c13e7afe744f18e18e4d19d0e74223e0d9bd5d782deea85dcb865feb7";
  };

  propagatedBuildInputs = [
    django-gravatar2 django-compressor django-allauth mailmanclient
  ];
  checkInputs = [ django mock ];

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
