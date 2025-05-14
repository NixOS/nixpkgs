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
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  libXxf86vm,
  libglvnd,
  zenity,
}:

let
  runLibDeps = [
    curl
    avahi
    jack2
    libxcb
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
    libXxf86vm
    libglvnd
  ];

  runBinDeps = [
    zenity
  ];
in

stdenv.mkDerivation rec {
  pname = "touchosc";
  version = "1.4.0.230";

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
        aarch64-linux = "sha256-RXv5j542pLApvp5y9EG6I/WWywoCFZx/F71mKusBSv4=";
        armv7l-linux = "sha256-5ySPBbB51tQjrhLpHzoEb5EPDv4nDGJL/hKQOSl3/YI=";
        x86_64-linux = "sha256-v7ePfkKxM/yu3KVQfDaK3dMij2TNfLY34ox5/dHJgGI=";
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

  meta = with lib; {
    homepage = "https://hexler.net/touchosc";
    description = "Next generation modular control surface";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-linux"
    ];
    mainProgram = "TouchOSC";
  };
}
