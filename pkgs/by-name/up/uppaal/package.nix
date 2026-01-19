{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  jdk17,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  shared-mime-info,
  gdk-pixbuf,
  autoPatchelfHook,
  stdenv,
  libxml2,
  zlib,
  openssl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "uppaal";
  version = "5.0";
  subversion = "0";
  platform = "linux64";

  src = fetchzip {
    url = "https://download.uppaal.org/uppaal-${version}/uppaal-${version}.${subversion}/uppaal-${version}.${subversion}-${platform}.zip";
    hash = "sha256-o71mP2/sDNRpmA1Qx59cvx6t4pk5pP0lrn1CogN3PuM=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "uppaal";
      exec = "uppaal %U";
      icon = "uppaal";
      comment = "real-time modelling and verification tool";
      desktopName = "Uppaal";
      genericName = "Uppaal";
      categories = [ "Development" ];
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    jdk17
    gdk-pixbuf
    shared-mime-info
    stdenv.cc.cc.lib
    openssl
    libxml2
    zlib
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib/uppaal
    for size in 16 32 48 64 96 128; do
      install -Dm444 res/icon-"$size"x"$size".png "$out"/share/icons/hicolor/"$size"x"$size"/apps/uppaal.png
    done

    cp -r * $out/lib/uppaal

    rm -f $out/lib/uppaal/bin/lib/libc.so*
    rm -f $out/lib/uppaal/bin/lib/libm.so*
    rm -f $out/lib/uppaal/bin/lib/libgcc_s.so*
    rm -f $out/lib/uppaal/bin/lib/libstdc++.so*
    rm -f $out/lib/uppaal/bin/lib/ld-linux.so*

    rm -f $out/lib/uppaal/bin/libcrypto.so*
    rm -f $out/lib/uppaal/bin/libssl.so*

    chmod +x $out/lib/uppaal/uppaal

    makeWrapper $out/lib/uppaal/uppaal $out/bin/uppaal \
      --set JAVA_HOME ${jdk17} \
      --set PATH $out/lib/uppaal:$PATH \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp"

    chmod +x $out/lib/uppaal/bin/verifyta

    makeWrapper $out/lib/uppaal/bin/verifyta $out/bin/verifyta \
      --set PATH $out/lib/uppaal:$PATH

    runHook postInstall
  '';

  meta = {
    description = "Integrated tool environment for modeling, validation and verification of real-time systems";
    homepage = "https://uppaal.org/";
    license = lib.licenses.unfreeRedistributable;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = !(stdenvNoCC.hostPlatform.isLinux && stdenvNoCC.hostPlatform.isx86_64);
    maintainers = with lib.maintainers; [ mortenmunk ];
    mainProgram = "uppaal";
  };
}
