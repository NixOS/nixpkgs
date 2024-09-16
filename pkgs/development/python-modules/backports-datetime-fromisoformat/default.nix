{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytz,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "backports-datetime-fromisoformat";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "movermeyer";
    repo = "backports.datetime_fromisoformat";
    rev = "refs/tags/v${version}";
    hash = "sha256-v9Njic7zN2bv1lQgdbJNeZLF3VXcC9A4UoE/znLF0gM=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytz
    pytestCheckHook
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'developmental_release'
    "release/test_developmental_release.py"
  ];

  pythonImportsCheck = [ "backports.datetime_fromisoformat" ];

  meta = with lib; {
    changelog = "https://github.com/movermeyer/backports.datetime_fromisoformat/releases/tag/v${version}";
    description = "Backport of Python 3.11's datetime.fromisoformat";
    homepage = "https://github.com/movermeyer/backports.datetime_fromisoformat";
    license = licenses.mit;
    maintainers = [ ];
  };
}
