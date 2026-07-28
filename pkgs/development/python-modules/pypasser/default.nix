{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonRelaxDepsHook,
  pydub,
  pysocks,
  requests,
  selenium,
  speechrecognition,
}:

buildPythonPackage rec {
  pname = "pypasser";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xHossein";
    repo = "PyPasser";
    tag = version;
    hash = "sha256-vqa+Xap9dYvjJMiGNGNmegh7rmAqwf3//MH47xwr/T0=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "speechrecognition"
  ];

  dependencies = [
    pydub
    pysocks
    requests
    selenium
    speechrecognition
  ];

  pythonImportsCheck = [
    "pypasser"
    "pypasser.reCaptchaV2"
    "pypasser.reCaptchaV3"
  ];

  # Package has no tests
  doCheck = false;

  meta = {
    description = "Bypassing reCaptcha V3 by sending HTTP requests & solving reCaptcha V2 using speech to text";
    homepage = "https://github.com/xHossein/PyPasser";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
