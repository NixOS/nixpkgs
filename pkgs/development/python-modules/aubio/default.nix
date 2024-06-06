{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytestCheckHook,
  stdenv,
  darwin,
}:

buildPythonPackage rec {
  pname = "aubio";
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aubio";
    repo = "aubio";
    rev = version;
    hash = "sha256-RvzhB1kQNP0IbAygwH2RBi/kSyuFPAHgsiCATPeMHTo=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Accelerate
      AudioToolbox
      CoreVideo
      CoreGraphics
    ]
  );

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aubio" ];

  meta = with lib; {
    description = "a library for audio and music analysis";
    homepage = "https://aubio.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
