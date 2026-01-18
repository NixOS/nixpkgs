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
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-auth-ldap";
    repo = "django-auth-ldap";
    tag = version;
    hash = "sha256-+ezadod2ZKrsNW7lVO1dVqQWUnzP1Mi9On8/RJ2qNfI=";
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

  meta = {
    changelog = "https://github.com/django-auth-ldap/django-auth-ldap/releases/tag/${src.tag}";
    description = "Django authentication backend that authenticates against an LDAP service";
    homepage = "https://github.com/django-auth-ldap/django-auth-ldap";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mmai ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
