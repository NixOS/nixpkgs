{
  lib,
  stdenv,
  runtimeShell,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  qt5,
  xdg-utils,
  shared-mime-info,
  adept2-runtime,
}:

let

  version = "3.23.4";

  sources = {
    x86_64-linux = {
      url = "https://files.digilent.com/Software/Waveforms2015/${version}/digilent.waveforms_${version}_amd64.deb";
      hash = "sha256-qJsZQAoy0gqtgjwbX8mZunIjnHUdRFohncOQiEBOZ1k=";
    };
    i686-linux = {
      url = "https://files.digilent.com/Software/Waveforms2015/${version}/digilent.waveforms_${version}_i386.deb";
      hash = "sha256-2djCeAEmTbKkhAShjFYlXUlUtHn/Ao5A4R52j5QEtvs=";
    };
    aarch64-linux = {
      url = "https://files.digilent.com/Software/Waveforms2015/${version}/digilent.waveforms_${version}_arm64.deb";
      hash = "sha256-rKJ+M5Dj8JlFNCjWTZlzCxojvDfveb662zYLAgGiGQc=";
    };
    armv7l-linux = {
      url = "https://files.digilent.com/Software/Waveforms2015/${version}/digilent.waveforms_${version}_armhf.deb";
      hash = "sha256-YgG2//mmQW1AH9ylWrxfBa3u35iqu+qdIzsok+XxF24=";
    };
  };

  srcInfo = lib.systems.${stdenv.targetPlatform.system};

  rewriteUsr = "rewrite-usr" + stdenv.targetPlatform.extensions.sharedLibrary;

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "waveforms";
  inherit version;

  src = fetchurl {
    url = source.url;
    hash = source.hash;
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    qt5.wrapQtAppsHook
    shared-mime-info
  ];

  buildInputs = [
    adept2-runtime
    qt5.qtbase
    qt5.qtscript
    qt5.qtmultimedia
    qt5.qtserialport
  ];

  runtimeDependencies = [ adept2-runtime ];

  unpackCmd = "dpkg -x $curSrc out";

  preFixup = ''
    qtWrapperArgs+=(--set LD_PRELOAD $out/lib/${rewriteUsr})
    qtWrapperArgs+=(--prefix PATH : $out/libexec:$out/bin)
    qtWrapperArgs+=(--set DIGILENT_ADEPT_CONF ${adept2-runtime}/etc/digilent-adept.conf)
  '';

  buildPhase = ''
    runHook preBuild

    $CC -Wall -std=c99 -O3 -fPIC -ldl -shared \
        -DDRV_DIR=\"$out\" \
        -o ${rewriteUsr} ${./rewrite-usr.c}

    cat > xdg-open <<EOF
    #!${runtimeShell}
    if [ "\$1" = "file:///usr/share/digilent/waveforms/" ]; then
        shift
        exec ${xdg-utils}/bin/xdg-open "file://$out/share/digilent/waveforms"
    else
        exec ${xdg-utils}/bin/xdg-open "\$@"
    fi
    EOF
    chmod +x xdg-open

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share $out/libexec
    rm -r usr/share/lintian
    cp -a usr/* $out/
    mv $out/share/digilent/waveforms/doc $out/bin/
    cp -a ${rewriteUsr} $out/lib/
    cp -a xdg-open $out/libexec/
    substituteInPlace $out/share/applications/digilent.waveforms.desktop \
        --replace /usr/bin $out/bin \
        --replace /usr/share $out/share

    runHook postInstall
  '';

  meta = {
    description = "Digilent Waveforms";
    homepage = "https://store.digilentinc.com/digilent-waveforms/";
    downloadPage = "https://mautic.digilentinc.com/waveforms-download";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      liff
      phodina
    ];
    mainProgram = "waveforms";
  };
})
