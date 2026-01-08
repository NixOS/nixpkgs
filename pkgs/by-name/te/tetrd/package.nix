{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  c-ares,
  ffmpeg,
  libevent,
  libvpx,
  libxslt,
  xorg,
  minizip,
  nss,
  re2,
  snappy,
  libnotify,
  libappindicator-gtk3,
  libappindicator,
  udev,
  libgbm,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "tetrd";
  version = "1.3.1-1";

  src = fetchurl {
    url = "https://web.archive.org/web/20260108185127/https://download.tetrd.app/files/tetrd.linux_amd64.pkg.tar.xz";
    sha256 = "0mpixs20jrxkbxvd7nl0p664jgqfp3m6qf7kmsj7frkhky697fbm";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libGL
    c-ares
    ffmpeg
    libevent
    libvpx
    libxslt
    xorg.libXScrnSaver
    xorg.libXdamage
    xorg.libXtst
    minizip
    nss
    re2
    snappy
    libnotify
    libappindicator-gtk3
    libappindicator
    udev
    libgbm
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r $sourceRoot/opt/Tetrd $out/opt
    cp -r $sourceRoot/usr/share $out

    wrapProgram $out/opt/Tetrd/tetrd \
      --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath buildInputs}

    mkdir $out/bin
    ln -s $out/opt/Tetrd/tetrd $out/bin/tetrd

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/tetrd.desktop --replace /opt $out/opt
  '';

  meta = {
    description = "Share your internet connection from your device to your PC and vice versa through a USB cable";
    homepage = "https://tetrd.app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "tetrd";
  };
}
