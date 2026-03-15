{
  lib,
  stdenv,
  stdenvNoCC,
  autoreconfHook,
  fetchFromGitHub,
  fetchurl,
  ffmpeg,
  freetype,
  libGLU,
  libjack2,
  liblo,
  libx11,
  libxv,
  pkg-config,
  portmidi,
  libxpm,
  libxext,
  undmg,
}:

let
  version = "0.8.15";
  meta = {
    description = "X Jack Video Monitor";
    longDescription = ''
      Xjadeo is a software video player that displays a video-clip in sync with
      an external time source (MTC, LTC, JACK-transport). Xjadeo is useful in
      soundtrack composition, video monitoring or any task that requires to
      synchronizing movie frames with external events.
    '';
    homepage = "https://xjadeo.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ mitchmindtree ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    pname = "xjadeo";
    inherit version;

    src = fetchurl rec {
      name =
        if stdenvNoCC.hostPlatform.isAarch64 then "jadeo-arm64-${version}.dmg" else "jadeo-${version}.dmg";
      url = "mirror://sourceforge/project/xjadeo/xjadeo/v${version}/${name}";
      hash =
        if stdenvNoCC.hostPlatform.isAarch64 then
          "sha256-iS/GjrrCBez7LembngSECGBjYev6Zz7j5Lxf9R0/Dhw="
        else
          "sha256-h0utV8Ri5yd+C8M8/7wG6zAkJQLPfmnrYQeHLcvHRgI=";
    };

    sourceRoot = ".";
    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications" "$out/bin"
      mv Jadeo.app "$out/Applications/"
      ln -s "$out/Applications/Jadeo.app/Contents/MacOS/Jadeo" "$out/bin/xjadeo"
      ln -s "$out/Applications/Jadeo.app/Contents/MacOS/xjremote" "$out/bin/xjremote"

      runHook postInstall
    '';

    meta = meta // {
      mainProgram = "xjadeo";
      platforms = lib.platforms.darwin;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
else
  stdenv.mkDerivation {
    pname = "xjadeo";
    inherit version;

    src = fetchFromGitHub {
      owner = "x42";
      repo = "xjadeo";
      tag = "v${version}";
      hash = "sha256-/8CxOPDbtr82XuJwBH+Yta6SJB7bsujOPBGwbxrmjZc=";
    };

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];

    buildInputs = [
      ffmpeg
      libjack2
      libx11
      libxext
      libxpm
      # The following are recommended in the README, but are seemingly
      # unnecessary for a successful build. That said, the result of including
      # these in the build process is possibly required at runtime in some cases,
      # but I've not the time to test thoroughly for these cases. Should
      # consider investigating and splitting these into options in the future.
      freetype
      libGLU
      liblo
      libxv
      portmidi
    ];

    meta = meta // {
      platforms = lib.platforms.linux;
    };
  }
