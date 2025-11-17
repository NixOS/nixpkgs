{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  makeDesktopItem,
  glib,
  qt5,
  libsForQt5,
  perl,
  libcxx,
  autoPatchelfHook,
  copyDesktopItems,
}:

let
  pluginsdk = fetchzip {
    url = "https://files.teamspeak-services.com/releases/sdk/3.3.1/ts_sdk_3.3.1.zip";
    hash = "sha256-wx4pBZHpFPoNvEe4xYE80KnXGVda9XcX35ho4R8QxrQ=";
  };
in

stdenv.mkDerivation rec {
  pname = "teamspeak3";

  version = "3.6.2";

  src = fetchurl {
    url = "https://files.teamspeak-services.com/releases/client/${version}/TeamSpeak3-Client-linux_amd64-${version}.run";
    hash = "sha256-WfEQQ4lxoj+QSnAOfdCoEc+Z1Oa5dbo6pFli1DsAZCI=";
  };

  nativeBuildInputs = [
    perl # Installer script needs `shasum`
    qt5.wrapQtAppsHook
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    libsForQt5.quazip
    glib
    libcxx
  ]
  ++ (with qt5; [
    qtbase
    qtwebengine
    qtwebchannel
    qtwebsockets
    qtsvg
  ]);

  # This runs the installer script. If it gets stuck, run it with -x.
  # If it then gets stuck at something like:
  #
  # ++ exec
  # + PAGER_PATH=
  #
  # it's looking for a dependency and didn't find it. Check the script and make
  # sure the dep is in nativeBuildInputs.
  unpackPhase = ''
    runHook preUnpack

    # Run the installer script non-interactively
    echo -e '\ny' | PAGER=cat sh -e $src

    cd TeamSpeak3-Client-linux_amd64

    runHook postUnpack
  '';

  patchPhase = ''
    runHook prePatch

    # Delete unecessary libraries - these are provided by nixos.
    find . -\( -name '*.so' -or -name '*.so.*' -\) -print0 | xargs -0 rm # I hate find.

    rm QtWebEngineProcess
    rm qt.conf

    mv ts3client_linux_amd64 ts3client

    # Our libquazip's so name has this suffix and there is no symlink
    patchelf --replace-needed libquazip.so libquazip1-qt5.so ts3client error_report

    runHook postPatch
  '';

  dontConfigure = true;
  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "teamspeak";
      exec = "ts3client";
      icon = "teamspeak";
      comment = "The TeamSpeak voice communication tool";
      desktopName = "TeamSpeak";
      genericName = "TeamSpeak";
      categories = [ "Network" ];
    })
  ];

  qtWrapperArgs = [
    # wayland is currently broken, remove when TS3 fixes that
    "--set QT_QPA_PLATFORM xcb"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/teamspeak
    mv * $out/opt/teamspeak/

    # Grab the desktop icon from the plugin sdk
    install ${pluginsdk}/doc/_static/logo.png -D $out/share/icons/hicolor/64x64/apps/teamspeak.png

    mkdir -p $out/bin/
    ln -s $out/opt/teamspeak/ts3client $out/bin/ts3client

    runHook postInstall
  '';

  meta = {
    description = "TeamSpeak voice communication tool";
    homepage = "https://teamspeak.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.teamspeak;
    maintainers = with lib.maintainers; [
      lhvwb
      lukegb
      atemu
    ];
    mainProgram = "ts3client";
    platforms = [ "x86_64-linux" ];
  };
}
