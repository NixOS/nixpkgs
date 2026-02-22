{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  curl,
  avahi,
  jack2,
  libxcb,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libxxf86vm,
  libglvnd,
  zenity,
}:

let
  runLibDeps = [
    curl
    avahi
    jack2
    libxcb
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    libxrender
    libxxf86vm
    libglvnd
  ];

  runBinDeps = [
    zenity
  ];
in

stdenv.mkDerivation rec {
  pname = "touchosc";
  version = "1.4.8.246";

  suffix =
    {
      aarch64-linux = "linux-arm64";
      armv7l-linux = "linux-armhf";
      x86_64-linux = "linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://hexler.net/pub/${pname}/${pname}-${version}-${suffix}.deb";
    hash =
      {
        aarch64-linux = "sha256-51xl39B0EzCjiqb2Ej6xoY3634DVYCcpQt68tHbsYd4=";
        armv7l-linux = "sha256-IJxQGRnGdBSj7t6C76bIeLtGlehhXExCbN1v0w+gMg4=";
        x86_64-linux = "sha256-amyaAmAKPPlWYT6rV8HKqyowqCSxKyHo0/8Mh8oyuyQ=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/share $out/share

    mkdir -p $out/bin
    cp opt/touchosc/TouchOSC $out/bin/TouchOSC

    wrapProgram $out/bin/TouchOSC \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runLibDeps} \
      --prefix PATH : ${lib.makeBinPath runBinDeps}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://hexler.net/touchosc";
    description = "Next generation modular control surface";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-linux"
    ];
    mainProgram = "TouchOSC";
  };
}
