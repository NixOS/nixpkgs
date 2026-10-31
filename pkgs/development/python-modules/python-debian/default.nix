{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  charset-normalizer,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-debian";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "python-debian-team";
    repo = "python-debian";
    tag = finalAttrs.version;
    hash = "sha256-K5i0zDZXeAgoAdblqp+f5QX9FIZYVpJ4wWk29hwVjfM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies.encodings = [
    charset-normalizer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/test_debfile.py"
  ];

  pythonImportsCheck = [ "debian" ];

  meta = {
    description = "Debian package related modules";
    homepage = "https://salsa.debian.org/python-debian-team/python-debian";
    changelog = "https://salsa.debian.org/python-debian-team/python-debian/-/blob/master/debian/changelog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
