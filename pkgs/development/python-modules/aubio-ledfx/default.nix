{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg-headless,
  libsamplerate,
  libsndfile,
  meson-python,
  numpy,
  pkg-config,
  pytestCheckHook,
  rubberband,
  setuptools,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "aubio-ledfx";
  version = "0.4.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "aubio-ledfx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g/VdeoQSkq8FB3uWK0A+KME7OCmQTa4gjr7iGDwq0gU=";
  };

  build-system = [
    meson-python
    setuptools
  ];

  dependencies = [ numpy ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libsamplerate
    libsndfile
  ]
  ++ lib.optionals stdenv.targetPlatform.isLinux [
    ffmpeg-headless
  ]
  ++ lib.optionals (!stdenv.targetPlatform.isLinux) [
    rubberband
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aubio" ];

  meta = {
    description = "Collection of tools for music analysis";
    homepage = "https://github.com/LedFx/aubio-ledfx";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
