{ lib, buildPythonPackage, fetchPypi, django-gravatar2, django_compressor
, django-allauth, mailmanclient, django, mock
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd3cb1ac26a3658bd694b82f00eaab98903bd2edff34956e90c187c9ab5c0dae";
  };

  propagatedBuildInputs = [
    django-gravatar2 django_compressor django-allauth mailmanclient
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
    maintainers = with maintainers; [ globin peti qyliss ];
  };
}
