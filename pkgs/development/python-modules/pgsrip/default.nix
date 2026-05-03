{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build dependencies
  poetry-core,

  # dependencies
  babelfish,
  cleanit,
  click,
  numpy,
  opencv-python,
  pysrt,
  pytesseract,
  setuptools,
  trakit,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pgsrip";
  version = "0.1.12";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "pgsrip";
    tag = version;
    hash = "sha256-8UzElhMdhjZERdogtAbkcfw67blk9lOTQ09vjF5SXm4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    babelfish
    cleanit
    click
    numpy
    opencv-python
    pysrt
    pytesseract
    setuptools
    trakit
  ];

  pythonRelaxDeps = [
    "babelfish"
    "cleanit"
    "click"
    "numpy"
    "opencv-python"
    "pytesseract"
    "setuptools"
    "trakit"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests require tesseract and sample files
  doCheck = false;

  pythonImportsCheck = [ "pgsrip" ];

  meta = {
    description = "Rip your PGS subtitles";
    homepage = "https://github.com/ratoaq2/pgsrip";
    changelog = "https://github.com/ratoaq2/pgsrip/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "pgsrip";
    maintainers = with lib.maintainers; [ sophronesis ];
  };
}
