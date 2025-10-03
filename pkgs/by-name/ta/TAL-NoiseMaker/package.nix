{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  freetype,
  alsa-lib,
  libatomic_ops,
}:

stdenv.mkDerivation rec {
  pname = "TAL-NoiseMaker";
  version = "5.0.6";

  src = fetchzip {
    url = "https://archive.org/download/tal-noise-maker-64-linux-${version}/TAL-NoiseMaker_64_linux_${version}.zip";
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

    mkdir -p $out/lib/{vst,vst3,clap}

    pushd TAL-NoiseMaker
      cp    libTAL-NoiseMaker.so $out/lib/vst/
      cp -r TAL-NoiseMaker.vst3  $out/lib/vst3/
      cp    TAL-NoiseMaker.clap  $out/lib/clap/
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
}
