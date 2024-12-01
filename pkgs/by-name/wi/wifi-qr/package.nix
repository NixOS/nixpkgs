{ lib
, fetchFromGitHub
, installShellFiles
, makeWrapper
, zenity
, ncurses
, networkmanager
, patsh
, procps
, qrencode
, stdenvNoCC
, xdg-utils
, zbar
}:
stdenvNoCC.mkDerivation {
  pname = "wifi-qr";
  version = "0.3-unstable-2023-09-30";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "kokoye2007";
    repo = "wifi-qr";
    rev = "821892001f735dc250a549ea36329cdc767db9c9";
    hash = "sha256-kv0qjO+wn4t//NmKkHB+tZB4eRNm+WRUa5rij+7Syuk=";
  };

  buildInputs = [
    zenity
    ncurses
    networkmanager
    procps
    qrencode
    xdg-utils
    zbar
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    patsh
  ];

  dontBuild = true;

  dontConfigure = true;

  postPatch = ''
    substituteInPlace src/wifi-qr.desktop \
      --replace "Icon=wifi-qr.svg" "Icon=wifi-qr"
    substituteInPlace src/wifi-qr \
      --replace "/usr/share/doc/wifi-qr/copyright" "$out/share/doc/wifi-qr/copyright"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 src/wifi-qr $out/bin/wifi-qr

    install -Dm644 src/wifi-qr.desktop $out/share/applications/wifi-qr.desktop
    install -Dm644 src/wifi-qr.svg $out/share/icons/hicolor/scalable/apps/wifi-qr.svg
    install -Dm644 src/LICENSE $out/share/doc/wifi-qr/copyright

    installManPage src/wifi-qr.1

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchShebangs $out/bin/wifi-qr
    patsh -f $out/bin/wifi-qr -s ${builtins.storeDir}

    runHook postFixup
  '';

  meta = with lib; {
    description = "WiFi password sharing via QR codes";
    homepage = "https://github.com/kokoye2007/wifi-qr";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "wifi-qr";
    platforms = platforms.linux;
  };
}
