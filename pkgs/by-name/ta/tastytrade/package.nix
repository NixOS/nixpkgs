{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, makeBinaryWrapper
, alsa-lib
, atk
, at-spi2-atk
, cairo
, cups
, dbus
, expat
, freetype
, glib
, gtk3
, libdrm
, libGL
, libxkbcommon
, mesa
, nspr
, nss
, pango
, xdg-utils
, xorg
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tastytrade";
  version = "2.5.4";

  src = fetchurl {
    url = "https://download.tastytrade.com/desktop-2.x.x/${finalAttrs.version}/tastytrade-${finalAttrs.version}-1_amd64.deb";
    hash = "sha256-j1qTMeaxHLkpjpYL6zf3Q7aT4aR94LRG7tW3ZUHkCp0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    atk
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    freetype
    glib
    gtk3
    libdrm
    libGL
    libxkbcommon
    mesa
    nspr
    nss
    pango
    xdg-utils
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt/tastytrade/* $out

    mkdir $out/share/applications
    mv $out/lib/tastytrade-tastytrade.desktop $out/share/applications/tastytrade.desktop
    substituteInPlace $out/share/applications/tastytrade.desktop \
      --replace /opt/tastytrade/bin/ "" \
      --replace /opt/tastytrade/lib/tastytrade.png tastytrade \
      --replace Categories=tastyworks Categories=Finance
    echo StartupWMClass=tasty.javafx.launcher.LauncherFxApp >> $out/share/applications/tastytrade.desktop

    mkdir $out/share/icons
    mv $out/lib/tastytrade.png $out/share/icons

    addAutoPatchelfSearchPath $out/lib/runtime/lib
    addAutoPatchelfSearchPath $out/lib/runtime/lib/server

    wrapProgram $out/bin/tastytrade --prefix LD_LIBRARY_PATH : ${ lib.makeLibraryPath finalAttrs.buildInputs }:$out/lib/runtime/lib:$out/lib/runtime/lib/server
    mv $out/lib/app/tastytrade.cfg $out/lib/app/.tastytrade-wrapped.cfg

    runHook postInstall
  '';

  meta = with lib; {
    description = "Options, futures and stock trading brokerage";
    homepage = "https://tastytrade.com/trading-platforms/#desktop";
    changelog = "https://support.tastyworks.com/support/solutions/articles/43000435186-tastytrade-desktop-release-notes";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ prominentretail ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tastytrade";
  };
})
