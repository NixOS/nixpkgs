{ lib, buildPythonPackage, fetchPypi, django-gravatar2, django-compressor
, django-allauth, mailmanclient, django, mock
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GpI1W0O9aJpLF/mcS23ktJDZsP69S2zQy7drOiWBnTM=";
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
