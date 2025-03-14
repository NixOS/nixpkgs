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
}:

stdenv.mkDerivation rec {
  pname = "tetrd";
  version = "1.0.4";

  src = fetchurl {
    url = "https://web.archive.org/web/20211130190525/https://download.tetrd.app/files/tetrd.linux_amd64.pkg.tar.xz";
    sha256 = "1bxp7rg2dm9nnvkgg48xd156d0jgdf35flaw0bwzkkh3zz9ysry2";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
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

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/tetrd.desktop --replace /opt $out/opt
  '';

  meta = with lib; {
    description = "Share your internet connection from your device to your PC and vice versa through a USB cable";
    homepage = "https://tetrd.app";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Madouura ];
  };
}
