{ stdenv, buildPythonPackage, fetchPypi, django-gravatar2, django_compressor
, django-allauth, mailmanclient, django, mock
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e37b68bb47e9ae196ca19018f576e2c8c90189c5bd82d4e549d0c2f2f3f35fb";
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
    homepage = "https://gitlab.com/mailman/django-mailman3";
    license = licenses.gpl3;
    maintainers = with maintainers; [ globin peti ];
  };
}
