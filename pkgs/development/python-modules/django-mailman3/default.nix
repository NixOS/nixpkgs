{ stdenv, buildPythonPackage, fetchPypi, django-gravatar2, django_compressor
, django-allauth, mailmanclient, django, mock
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b05cf04b2c36916d15b78e24610002206529f1441e2632253a26b2db6bfd3b27";
  };

  propagatedBuildInputs = [
    django-gravatar2 django_compressor django-allauth mailmanclient
  ];
  checkInputs = [ django mock ];

  checkPhase = ''
    cd $NIX_BUILD_TOP/$sourceRoot
    PYTHONPATH=.:$PYTHONPATH django-admin.py test --settings=django_mailman3.tests.settings_test
  '';

  meta = with stdenv.lib; {
    description = "Django library for Mailman UIs";
    homepage = https://gitlab.com/mailman/django-mailman3;
    license = licenses.gpl3;
    maintainers = with maintainers; [ globin peti ];
  };
}
