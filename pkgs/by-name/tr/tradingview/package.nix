{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, squashfsTools
, makeBinaryWrapper
, alsa-lib
, atk
, at-spi2-atk
, cups
, gtk3
, libdrm
, libsecret
, libxkbcommon
, mesa
, pango
, sqlite
, systemd
, wayland
, xorg
}:

stdenv.mkDerivation rec {
  pname = "tradingview";
  version = "2.6.1";
  revision = "44";
  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/nJdITJ6ZJxdvfu8Ch7n5kH5P99ClzBYV_${revision}.snap";
    hash = "sha512-Hd00TWjPskd0QDzpOSwQCuMw20nW4n1xxRkT1rA95pzbXtw7XFxrJdMWkzWDbucuokU2qR2b5tovAHAgw9E0tQ==";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    squashfsTools
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    atk
    at-spi2-atk
    cups
    gtk3
    libdrm
    libsecret
    libxkbcommon
    mesa
    pango
    sqlite
    systemd
    wayland
    xorg.libxcb
    xorg.libX11
    xorg.libXext
  ];

  unpackPhase = ''
    runHook preUnpack
    unsquashfs $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r squashfs-root $out/share/tradingview
    rm -rf $out/share/tradingview/meta

    install -Dm444 squashfs-root/meta/gui/tradingview.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/tradingview.desktop --replace \$\{SNAP}/meta/gui/icon.png tradingview

    mkdir $out/share/icons
    cp squashfs-root/meta/gui/icon.png $out/share/icons/tradingview.png

    mkdir $out/bin
    makeBinaryWrapper $out/share/tradingview/tradingview $out/bin/tradingview --prefix LD_LIBRARY_PATH : ${ lib.makeLibraryPath buildInputs }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Charting platform for traders and investors";
    homepage = "https://www.tradingview.com/desktop/";
    changelog = "https://www.tradingview.com/support/solutions/43000673888/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ prominentretail ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tradingview";
  };
}
