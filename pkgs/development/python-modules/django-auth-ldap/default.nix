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
<<<<<<< HEAD
  version = "4.5.0";
=======
  version = "4.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-B6L+NbQCUIluErjWLROW0eQ3AEYwNwN2BJPOzXkfqI8=";
=======
    hash = "sha256-eItbHucAVGgdf659CF3qp28vpvZMyf49152u9iwvYSE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
