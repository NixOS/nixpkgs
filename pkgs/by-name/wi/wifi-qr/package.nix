{
  lib,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  zenity,
  ncurses,
  networkmanager,
  patsh,
  procps,
  qrencode,
  stdenvNoCC,
  xdg-utils,
  zbar,
  coreutils,
  gnused,
  gnugrep,
  file,
}:
stdenvNoCC.mkDerivation (finalAttr: {
  pname = "wifi-qr";
  version = "0.4";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "kokoye2007";
    repo = "wifi-qr";
    tag = "v${finalAttr.version}";
    hash = "sha256-tE+9bFDgiFS1Jj+AAwTMKjMh5wS5/gkRSQaCBR/riYQ=";
  };

  buildInputs = [
    zenity
    ncurses
    networkmanager
    procps
    qrencode
    xdg-utils
    zbar
    # needed for cross
    # TODO: somehow splice the packages in stdenvNoCC.initialPath and use that
    coreutils
    gnugrep
    gnused
    file
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    patsh
  ];

  dontBuild = true;

  dontConfigure = true;

  postPatch = ''
    substituteInPlace wifi-qr.desktop \
      --replace-fail "Icon=wifi-qr.svg" "Icon=wifi-qr"
    substituteInPlace wifi-qr \
      --replace-fail "/usr/share/doc/wifi-qr/copyright" "$out/share/doc/wifi-qr/copyright"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 wifi-qr $out/bin/wifi-qr

    install -Dm644 wifi-qr.desktop $out/share/applications/wifi-qr.desktop
    install -Dm644 wifi-qr.svg $out/share/icons/hicolor/scalable/apps/wifi-qr.svg
    install -Dm644 LICENSE $out/share/doc/wifi-qr/copyright

    installManPage wifi-qr.1

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchShebangs $out/bin/wifi-qr
    patsh -f $out/bin/wifi-qr -s ${builtins.storeDir} --path "$HOST_PATH"

    runHook postFixup
  '';

  meta = {
    description = "WiFi password sharing via QR codes";
    homepage = "https://github.com/kokoye2007/wifi-qr";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "wifi-qr";
    platforms = lib.platforms.linux;
  };
})
