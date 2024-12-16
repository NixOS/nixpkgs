{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
  pyotp,
  fido2,
  qrcode,
  python,
}:

buildPythonPackage rec {
  pname = "django-mfa3";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xi";
    repo = "django-mfa3";
    rev = "refs/tags/${version}";
    hash = "sha256-O8po7VevqyHlP2isnNnLbpgfs1p4sFezxIZKMTgnwuY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pyotp
    fido2
    qrcode
  ];

  # qrcode 8.0 not supported yet
  # See https://github.com/xi/django-mfa3/pull/14
  pythonRelaxDeps = [ "qrcode" ];

  checkPhase = ''
    # Disable failing test test_origin_https
    # https://github.com/xi/django-mfa3/issues/24
    ${python.interpreter} -m django test --settings tests.settings -k "not test_origin_https"
  '';

  meta = {
    description = "Multi factor authentication for Django";
    homepage = "https://github.com/xi/django-mfa3";
    changelog = "https://github.com/xi/django-mfa3/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
