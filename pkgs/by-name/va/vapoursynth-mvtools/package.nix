{
  lib,
  stdenv,
  fetchPypi,
  python3Packages,
  vapoursynth,
  pkg-config,
  nasm,
  fftwFloat,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "vapoursynth-mvtools";
  version = "29";
  pyproject = true;

  src = fetchPypi {
    pname = "vapoursynth_mvtools";
    inherit (finalAttrs) version;
    hash = "sha256-4XTunwe8xAWMVyVZVy3lxE46hHsI3WWFIKkTCicsWH4=";
  };

  build-system = [
    python3Packages.meson-python
  ];

  nativeBuildInputs = [
    nasm
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    fftwFloat
  ];

  meta = {
    description = "Set of filters for motion estimation and compensation";
    homepage = "https://github.com/dubhatervapoursynth/vapoursynth-mvtools";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
})
