{
  buildPythonPackage,
  cryptography,
  django,
  django-appconf,
  fetchFromGitHub,
  lib,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-cryptography";
  version = "1.1";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "georgemarshall";
    repo = "django-cryptography";
    tag = version;
    hash = "sha256-C3E2iT9JdLvF+1g+xhZ8dPDjjh25JUxLAtTMnalIxPk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    django
    django-appconf
  ];

  patches = [
    # See: https://github.com/georgemarshall/django-cryptography/pull/88
    ./fix-setup-cfg.patch
  ];

  pythonImportsCheck = [ "django_cryptography" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} ./runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/georgemarshall/django-cryptography";
    description = "Set of primitives for performing cryptography in Django";
    license = licenses.bsd3;
    maintainers = with maintainers; [ centromere ];
  };
}
