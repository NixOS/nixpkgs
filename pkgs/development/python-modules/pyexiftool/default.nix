{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  exiftool,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyexiftool";
  version = "0.5.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sylikc";
    repo = "pyexiftool";
    rev = "refs/tags/v${version}";
    hash = "sha256-dgQkbpCbdq2JbupY0DyQbHPR9Bg+bwDo7yN03o3sX+A=";
  };

  postPatch = ''
    substituteInPlace exiftool/constants.py \
      --replace-fail 'DEFAULT_EXECUTABLE = "exiftool"' \
                     'DEFAULT_EXECUTABLE = "${lib.getExe exiftool}"'
  '';

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "exiftool" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/sylikc/pyexiftool/blob/${src.rev}/CHANGELOG.md";
    description = "Python wrapper for exiftool";
    homepage = "https://github.com/sylikc/pyexiftool";
    license = with lib.licenses; [
      bsd3 # or
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
