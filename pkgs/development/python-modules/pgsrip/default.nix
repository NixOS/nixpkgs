{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  nix-update-script,
  pythonRelaxDepsHook,
  poetry-core,
  babelfish,
  cleanit,
  click,
  numpy,
  opencv4,
  pysrt,
  pytesseract,
  trakit,
}:

buildPythonPackage rec {
  pname = "pgsrip";
  version = "0.1.11";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "pgsrip";
    rev = version;
    hash = "sha256-H9gZXge+m/bCq25Fv91oFZ8Cq2SRNrKhOaDrLZkjazg=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    poetry-core
  ];

  dependencies = [
    babelfish
    cleanit
    click
    numpy
    opencv4
    pysrt
    pytesseract
    trakit
  ];

  patchPhase = ''
    substituteInPlace pyproject.toml --replace "opencv-python" "opencv"
  '';

  pythonRelaxDeps = [
    "babelfish"
    "numpy"
    "setuptools"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ratoaq2/pgsrip/releases/tag/${version}";
    description = "Rip your PGS subtitles";
    homepage = "https://github.com/ratoaq2/pgsrip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
