{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  alsa-lib,
  libjack2,
  curl,
  xorg,
  libGL,
  freetype,
  zenity,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  icon = fetchurl {
    url = "https://vital.audio/images/apple_touch_icon.png";
    hash = "sha256-NZ/AQ2gjBXUPUj3ITbowD7HuxRmEDuATOWidLqLNrww=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vital";
  version = "1.5.5";

  src = fetchzip {
    url = "https://builds.vital.audio/VitalAudio/vital/${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }/VitalInstaller.zip";
    hash = "sha256-hCwXSUiBB0YpQ1oN6adLprwAoel6f72tBG5fEb61OCI=";
  };
  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "vital";
      desktopName = "Vital";
      comment = "Spectral warping wavetable synth";
      icon = "Vital";
      exec = "Vital";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    (lib.getLib stdenv.cc.cc)
    libGL
    xorg.libSM
    xorg.libICE
    xorg.libX11
    freetype
    libjack2
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 ${icon} $out/share/pixmaps/Vital.png

    # copy each output to its destination (individually)
    mkdir -p $out/{bin,lib/{clap,vst,vst3}}
    for f in bin/Vital lib/{clap/Vital.clap,vst/Vital.so,vst3/Vital.vst3}; do
      cp -r $f $out/$f
    done

    wrapProgram $out/bin/Vital \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          curl
          libjack2
        ]
      }" \
      --prefix PATH : "${
        lib.makeBinPath [
          zenity
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "Spectral warping wavetable synth";
    homepage = "https://vital.audio/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree; # https://vital.audio/eula/
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      PowerUser64
      l1npengtul
    ];
    mainProgram = "Vital";
  };
})
