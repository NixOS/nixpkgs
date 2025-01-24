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
  fetchpatch,
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

  patches = [
    # Fix for tests.tests.FIDO2Test.test_origin_https
    # https://github.com/xi/django-mfa3/issues/24
    (fetchpatch {
      url = "https://github.com/xi/django-mfa3/commit/49003746783e32cd60e55c4593bef5d7e709c4bd.patch";
      hash = "sha256-D3fPURAB+RC16fSd2COpCIcmjZW/1h92GOOhRczSVec=";
      name = "test_origin_https_fix.patch";
    })
  ];

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
    ${python.interpreter} -m django test --settings tests.settings
  '';

  meta = {
    description = "Multi factor authentication for Django";
    homepage = "https://github.com/xi/django-mfa3";
    changelog = "https://github.com/xi/django-mfa3/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
