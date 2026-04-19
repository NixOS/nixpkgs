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
  pname = "aubio";
  version = "0.4.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "aubio-ledfx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ec6QiTj1AOza+ggJPl3EULNDB/rrpCDZW0HaSywy/4E=";
  };

  build-system = [
    meson-python
    setuptools
  ];

  dependencies = [ numpy ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ffmpeg-headless
    libsamplerate
    libsndfile
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
