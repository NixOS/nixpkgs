{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # buildtime
  setuptools-scm,

  # runtime
  django,
  python-ldap,

  # tests
  openldap,
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-auth-ldap";
    repo = "django-auth-ldap";
    tag = version;
    hash = "sha256-uOxncRsBwy+1ynESku7+5yaY1MPIo4V8ppE2zfcDkws=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    django
    python-ldap
  ];

  # Duplicate attributeType: "MSADat2:102"\nslapadd: could not add entry dn="cn={4}msuser,cn=schema,cn=config" (line=1): \xd0\xbe\xff\xff\xff\x7f\n'
  doCheck = false;

  preCheck = ''
    export PATH=${openldap}/bin:${openldap}/libexec:$PATH
    export SCHEMA=${openldap}/etc/schema
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  checkPhase = ''
    runHook preCheck
    python -m django test --settings tests.settings
    runHook postCheck
  '';

  pythonImportsCheck = [ "django_auth_ldap" ];

  meta = with lib; {
    description = "Django authentication backend that authenticates against an LDAP service";
    homepage = "https://github.com/django-auth-ldap/django-auth-ldap";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
