{
  lib,
  stdenv,
  symlinkJoin,
  makeBinaryWrapper,
  makeDesktopItem,
  electron_43,
  libicns,
  writeDarwinBundle,
  enableAzureDevOps ? false,
  enableBitbucket ? false,
  enableClaude ? false,
  enableCodex ? true,
  enableCursor ? false,
  enableCursorCli ? false,
  enableGitHub ? true,
  enableGit ? true,
  enableGitLab ? false,
  enableJujutsu ? false,
  enableOpencode ? false,
  enableResourceMonitor ? true,
  t3code-cli,
}:

let
  appName = "T3 Code (Alpha)";
  electron = electron_43;
  configuredCli = t3code-cli.override {
    inherit
      enableAzureDevOps
      enableBitbucket
      enableClaude
      enableCodex
      enableCursor
      enableCursorCli
      enableGitHub
      enableGit
      enableGitLab
      enableJujutsu
      enableOpencode
      enableResourceMonitor
      ;
  };
  t3code-unwrapped = configuredCli.unwrapped.override { enableDesktop = true; };
  desktopIcon =
    if stdenv.hostPlatform.isDarwin then
      "${t3code-unwrapped.src}/assets/prod/black-macos-1024.png"
    else
      "${t3code-unwrapped.src}/assets/prod/black-universal-1024.png";

  # symlinkJoin does not run the copyDesktopItems hook, so the entry is
  # merged into `paths` instead.
  desktopItem = makeDesktopItem {
    name = "t3code";
    desktopName = appName;
    comment = "Desktop agent harness control surface";
    exec = "t3code-desktop %U";
    terminal = false;
    icon = "t3code";
    startupWMClass = "t3code";
    categories = [ "Development" ];
  };

in
symlinkJoin {
  pname = "t3code-desktop";
  inherit (t3code-unwrapped) version;
  __structuredAttrs = true;
  strictDeps = true;

  paths = [ t3code-unwrapped ] ++ lib.optionals stdenv.hostPlatform.isLinux [ desktopItem ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libicns
    writeDarwinBundle
  ];

  postBuild = ''
    makeWrapper ${lib.getExe electron} "$out/bin/t3code-desktop" \
      --add-flags "$out/libexec/t3code-desktop/apps/desktop" \
      --set T3CODE_SERVER_ROOT "${configuredCli.unwrapped}/libexec/t3code" \
      --inherit-argv0 ${lib.escapeShellArgs configuredCli.wrapperArgs}
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir --parents "$out/Applications/${appName}.app/Contents/"{MacOS,Resources}
    png2icns \
      "$out/Applications/${appName}.app/Contents/Resources/t3code.icns" \
      ${desktopIcon}

    # writeDarwinBundle is a shebangless bash script; run it explicitly via
    # stdenv.shell to avoid Darwin's intermittent ENOEXEC fallback issues.
    # It links the bundle executable against $out/bin/t3code-desktop, which
    # the wrapper above must have created first.
    ${stdenv.shell} ${lib.getExe writeDarwinBundle} \
      "$out" "${appName}" t3code-desktop t3code
  ''
  + ''
    mkdir --parents \
      "$out"/share/icons/hicolor/scalable/apps
    install --mode=444 ${desktopIcon} \
      "$out"/share/icons/t3code.png
    install --mode=444 ${t3code-unwrapped.src}/assets/prod/logo.svg \
      "$out"/share/icons/hicolor/scalable/apps/t3code.svg
  '';

  passthru.unwrapped = t3code-unwrapped;

  meta = {
    description = "Desktop agent harness control surface";
    mainProgram = "t3code-desktop";
    inherit (t3code-unwrapped.meta)
      homepage
      downloadPage
      changelog
      license
      maintainers
      platforms
      ;
  };
}
