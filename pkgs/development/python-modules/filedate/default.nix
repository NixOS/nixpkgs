{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  setuptools,
}:
buildPythonPackage rec {
  pname = "filedate";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kubinka0505";
    repo = "filedate";
    rev = version;
    hash = "sha256-HvuGP+QlUlfAUfFmaVVvtPHGdrbWVxghQipnqTTvAQc=";
  };

  sourceRoot = "${src.name}/Files";

  # The repo stores everything in "src" and uses setup.py to move "src" ->
  # "filedate" before calling setup() and then tries to rename "filedate" back
  # to "src" after.
  postPatch = ''
    mv src filedate
    substituteInPlace setup.py \
      --replace-fail "__title__ = os.path.basename(os.path.dirname(os.path.dirname(__file__)))" '__title__ = "filedate"'
    substituteInPlace setup.py \
      --replace-fail "cleanup = True" "cleanup = False"

    # Disable renaming "filedate" dir back to "src"
    substituteInPlace setup.py \
      --replace-fail "if os.path.exists(__title__):" ""
    substituteInPlace setup.py \
      --replace-fail "	os.rename(__title__, directory)" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  pythonImportsCheck = [ "filedate" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/unit.py" ];

  disabledTests = [ "test_created" ];

  meta = {
    description = "Simple, convenient and cross-platform file date changing library";
    homepage = "https://github.com/kubinka0505/filedate";
    changelog = "https://github.com/kubinka0505/filedate/blob/${src.rev}/Documents/ChangeLog.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ thornycrackers ];
  };
}
