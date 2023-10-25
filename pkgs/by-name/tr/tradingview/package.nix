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

    mkdir -p $out
    cp -r squashfs-root/* $out

    mkdir -p $out/share/applications
    mv $out/meta/gui/tradingview.desktop $out/share/applications
    substituteInPlace $out/share/applications/tradingview.desktop --replace \$\{SNAP} $out

    mkdir $out/bin
    makeBinaryWrapper $out/tradingview $out/bin/tradingview --prefix LD_LIBRARY_PATH : ${ lib.makeLibraryPath buildInputs }

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

