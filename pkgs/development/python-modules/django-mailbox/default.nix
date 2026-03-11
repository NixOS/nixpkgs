{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  pytest-django,
  pytestCheckHook,
  setuptools,
  six,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-mailbox";
  version = "4.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coddingtonbear";
    repo = "django-mailbox";
    tag = version;
    hash = "sha256-7CBUnqveTSfdc+8x8sZUqvwYW3vKjZKfOPVWFSo4es0=";
  };

  disabled = pythonOlder "3.8";

  dependencies = [
    django
    six
  ];

  build-system = [ setuptools ];
  doCheck = true;
  preCheck = ''
    substituteInPlace setup.cfg --replace-fail "pytest" "tool:pytest"
    export DJANGO_SETTINGS_MODULE=django_mailbox.tests.settings
  '';
  pythonImportsCheck = [ "django_mailbox" ];
  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Import mail from POP3, IMAP, local email mailboxes or directly from Postfix or Exim4 into your Django application automatically.";
    homepage = "https://github.com/coddingtonbear/django-mailbox";
    changelog = "https://github.com/coddingtonbear/django-mailbox/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
