{ stdenv, buildPythonPackage, fetchFromGitLab, mailmanclient, pytz
, django-gravatar2, django, django-allauth }:

buildPythonPackage rec {
  pname = "django-mailman3";
  name = "${pname}-${version}";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "mailman";
    repo = "django-mailman3";
    rev = version;
    sha256 = "0ac3yms7b9s50y9b4xvx0yxmj2dmibd0pb61j4rhqf7qb4mbs28k";
  };

  propagatedBuildInputs = [
    mailmanclient pytz django-gravatar2 django django-allauth
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Django library for Mailman UIs";
    homepage = https://gitlab.com/mailman/django-mailman3;
    license = licenses.gpl3;
    maintainers = with maintainers; [ globin ];
  };
}
