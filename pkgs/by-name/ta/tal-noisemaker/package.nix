{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  freetype,
  alsa-lib,
  libatomic_ops,

  installVST3 ? true,
  installVST2 ? true,
  installCLAP ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tal-noisemaker";
  version = "5.0.6";

  src = fetchzip {
    url = "https://archive.org/download/tal-noise-maker-64-linux-${finalAttrs.version}/TAL-NoiseMaker_64_linux_${finalAttrs.version}.zip";
    hash = "sha256-p6XUltjdpbCUvsqNmP6tRTIZ+uXC3rloAZoGo7nGrk8=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    freetype
    alsa-lib
    libatomic_ops
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    pushd TAL-NoiseMaker
      ${lib.optionalString installVST3 ''
        mkdir -p $out/lib/vst3
        cp TAL-NoiseMaker.vst3 $out/lib/vst3
      ''}

      ${lib.optionalString installVST2 ''
        mkdir -p $out/lib/vst
        cp libTAL-NoiseMaker.so $out/lib/vst
      ''}

      ${lib.optionalString installCLAP ''
        mkdir -p $out/lib/clap
        cp TAL-NoiseMaker.clap $out/lib/clap
      ''}
    popd

    runHook postInstall
  '';

  meta = {
    description = "Virtual analog synthesizer";
    homepage = "https://tal-software.com/products/TAL-NoiseMaker";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ mrtnvgr ];
  };
})
