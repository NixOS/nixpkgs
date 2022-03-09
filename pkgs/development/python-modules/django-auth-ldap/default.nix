{ lib
, buildPythonPackage
, fetchPypi
, isPy27

# buildtime
, setuptools-scm

# runtime
, ldap
, django

# tests
, python
, pkgs
}:

buildPythonPackage rec {
  pname = "django-auth-ldap";
  version = "4.0.0";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "276f79e624ce083ce13f161387f65ff1c0efe83ef8a42f2b9830d43317b15239";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    ldap
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
