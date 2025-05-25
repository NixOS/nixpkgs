{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  charset-normalizer,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.52";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "python-debian-team";
    repo = "python-debian";
    tag = version;
    hash = "sha256-+c+AiUCnpasOLbY6K4cuKUb6Ojwn0py78fL5W24WRwU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
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
}
