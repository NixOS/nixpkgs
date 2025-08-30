{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,

  alsa-lib,
  libjack2,
  curl,
  xorg,
  libGL,
  freetype,
  zenity,
}:

let
  iconPng = fetchurl {
    url = "https://vital.audio/images/vital_full_no_background.png";
    sha256 = "sha256-Qvt1v+9DVfrTFSZvi/zRf8iXZsej6Sq7KZhOjOYKpvo=";
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

    ln -s $out/bin/Vital $out/bin/vital

    install -D ${iconPng} $out/share/icons/hicolor/256x256/apps/vital.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      exec = finalAttrs.meta.mainProgram;
      name = "vital";
      icon = "vital";
      comment = finalAttrs.meta.description;
      desktopName = "Vital";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
    })
  ];

  meta = with lib; {
    description = "Spectral warping wavetable synth";
    homepage = "https://vital.audio/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      PowerUser64
      lortane
    ];
    mainProgram = "Vital";
  };
})
