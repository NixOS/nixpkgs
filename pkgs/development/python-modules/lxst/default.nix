{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  libpulseaudio,
  audioop-lts,
  lxmf,
  numpy,
  pycodec2,
  rns,
  soundcard,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxst";
  version = "0.6.0";
  format = "wheel";

  src = fetchPypi {
    pname = "lxst";
    version = finalAttrs.version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-xFi010YXSbAE3gKCGVO31ngqZcHEgelaNiGXaM0uoAQ=";
  };

  # We can't use a postPatch here to do the substitution because the wheel is
  # already built and the file is not present in the source tree, only the
  # wheel archive.
  postInstall = ''
    substituteInPlace "$out/lib/python"*/site-packages/LXST/Platforms/linux/soundcard.py \
      --replace-fail "libpulse.so" "${lib.getLib libpulseaudio}/lib/libpulse.so"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    audioop-lts
    pycodec2
    numpy
    rns
    lxmf
    soundcard
  ];

  meta = {
    changelog = "https://github.com/markqvist/LXST/releases/tag/${finalAttrs.version}";
    description = "Simple and flexible real-time streaming format and delivery protocol for Reticulum";
    homepage = "https://github.com/markqvist/LXST";
    license = lib.licenses.reticulum;
    maintainers = with lib.maintainers; [
      drupol
    ];
    mainProgram = "rnphone";
  };
})
