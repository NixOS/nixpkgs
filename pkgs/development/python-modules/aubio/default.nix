{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      # fix "incompatible function pointer types initializing 'PyUFuncGenericFunction'"
      name = "const-function-signature.patch";
      url = "https://github.com/aubio/aubio/commit/95ff046c698156f21e2ca0d1d8a02c23ab76969f.patch";
      hash = "sha256-qKcIPjpcZUizSN/t96WOiOn+IlsrlC0+g7gW77KejH0=";
    })
  ];

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
    description = "Library for audio and music analysis";
    homepage = "https://aubio.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
