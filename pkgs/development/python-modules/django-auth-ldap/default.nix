{ lib
, buildPythonPackage
, fetchPypi
, isPy27

# buildtime
, setuptools-scm

# runtime
, django
, python-ldap

# tests
, python
, pkgs
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "4.7.0";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jeplN2uLL6G+7lI0h2DjCC5kKTmlA4y+iBpeY4G2W4o=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    python-ldap
  ];

  # ValueError: SCHEMADIR is None, ldap schemas are missing.
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    export PATH=${pkgs.openldap}/bin:${pkgs.openldap}/libexec:$PATH
    ${python.interpreter} -m django test --settings tests.settings
    runHook postCheck
  '';

  pythonImportsCheck = [ "django_auth_ldap" ];

  meta = with lib; {
    description = "Django authentication backend that authenticates against an LDAP service";
    homepage = "https://github.com/django-auth-ldap/django-auth-ldap";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
    platforms = platforms.linux;
  };
}
