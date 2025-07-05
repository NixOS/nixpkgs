{
  ## Helpers to Nix packaging
  fetchFromGitHub,
  fetchYarnDeps,
  lib,

  ## Nix packaging tooling
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  autoPatchelfHook,

  ## Needed for Executing package.json scripts
  nodejs_22,
  python3,
  electron,

  ## Needed for Compiling the native modules
  pkg-config,
  libsecret,
  libX11,
  libxkbfile,

  ## Needed for Distribution
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,

  ## Needed for autoPatchelf / patchelf --print-needed ${electron}.bin
  # Linking bin
  # ffmpeg-headless,
  nss,
  nspr,
  dbus,
  atk,
  cups,
  libdrm,
  gtk3,
  pango,
  cairo,
  # xorg one's
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libxcb,

  libgbm,
  expat,
  libxkbcommon,
  alsa-lib,
  pulseaudio,
  flac,
  libxslt,
}:

let
  nodejs = nodejs_22;
in

stdenv.mkDerivation rec {
  pname = "theia-ide";
  version = "1.62.200";

  # executableName = pname;  # "TheiaIDE" ?

  src = fetchFromGitHub {
    owner = "eclipse-theia";
    repo = "theia-ide"; # Do NOT use pname here.
    tag = "v${version}";
    hash = "sha256-hjg+UEu+c4Mt7M34KZGxoYcHVR6hzs38/vZzOYPttJs=";
  };
  # src = ./.;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-/EdYMau3I+xgmbU6IuKRa6cNDyvqJLPVgHkPn0yS46I=";
  };

  env = {
    # DEBUG = "electron-rebuild";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    # `gyp verb get node dir` requires node headers
    npm_config_nodedir = "${nodejs}";
  };

  nativeBuildInputs = [
    ## Nix packaging tooling
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    autoPatchelfHook

    ## Needed for Executing package.json scripts
    nodejs
    (python3.withPackages (ps: [ ps.distutils ]))

    ## Needed for Distribution
    makeWrapper
    copyDesktopItems

    ## Needed for Compiling the native modules
    pkg-config
    libsecret
    libxkbfile
    libX11
  ];

  buildInputs = [
    ## Needed for autoPatchelf / patchelf --print-needed ${electron}.bin
    nss # lib{nss3,nssutil3,smime3}
    nspr
    dbus
    atk # libat{k,kbridge,spi}
    cups
    libdrm
    gtk3 # libgtk-3
    pango
    cairo
    libX11 # DONE ABOVE
    libxcb # DONE ABOVE
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libgbm
    expat
    libxkbcommon

    alsa-lib # libasound
    pulseaudio # libpulse
    flac
    libxslt

    # libffmpeg  # Use the bundled one: $out/lib
  ];

  # https://www.electron.build/#quick-setup-guide
  # yarn --offline electron build:prod  # ENOENT: node_modules/electron/dist/version

  buildPhase = ''
    runHook preBuild

    pushd ./node_modules/cpu-features
    node buildcheck.js > buildcheck.gypi
    popd

    yarn --offline electron package:preview \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      ;

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Package directory
    pushd ./applications/electron/dist/linux-unpacked
    mkdir -p "$out/lib/$pname"
    cp -r ./* "$out/lib/$pname"

    install -Dm444 ./resources/app/resources/icons/WindowIcon/512-512.png "$out/share/pixmaps/$pname.png"
    popd

    # Executable wrapper
    # makeWrapper '${electron}/bin/electron' "$out/bin/$pname" \
    #   --add-flags "$out/share/lib/$pname/resources/app.asar" \
    #   --inherit-argv0
    #   # --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \

    runHook postInstall
  '';

  # Inspiration for abstraction of "names" & content of desktopItems:
  # https://github.com/NixOS/nixpkgs/blob/382009d711/pkgs/by-name/ku/kuro/package.nix#L49-L82
  # https://github.com/VSCodium/vscodium/blob/376bde0817/src/stable/resources/linux/code.desktop
  # https://github.com/NixOS/nixpkgs/blob/382009d711/pkgs/applications/editors/vscode/generic.nix#L154
  # Full hashes: 382009d711a80a4d6d83752b22b652a51888dcea 376bde08171438978e8c63555805d6c95a8eedf3

  ## Plan:
  # desktopItems = {...}
  #   |> (names: { base = {...}; item-list = [{...} {...}]; })
  #   |> (data: map (item: data.base // item) data.item-list)
  #   |> map makeDesktopItem;

  # https://noogle.dev/f/lib/pipe
  # lib.pipe :: value [functions]
  desktopItems =
    lib.pipe

      # Abstracted attrset of names
      {
        exec = "theia-ide";
        # pname is specified for icon in installPhase, hence same here
        icon = "${pname}";
        long = "Theia IDE";
        short = "theia-ide";
      }

      [
        # Specify DRY parts of desktopItems as nix attribute sets (attrsets)
        (names: {

          # Common part in both items
          base = {
            icon = names.icon;
            genericName = "IDE";
            comment = meta.description;
            startupNotify = true;
            # TODO: Confirm this startupWMClass from artifact / upstream
            startupWMClass = names.short;
            categories = [
              # Theia-IDE / vscode / vscodium are NOT "small Utility applications"
              # "Utility"
              "Development"
              "IDE"
              "TextEditor"
            ];
            keywords = [
              "eclipse"
              "vscode"
              "text editor"
            ];
          };

          # 'name': basename-no-ext of .desktop file; desktopName: 'Name' field
          item-list = [
            {
              # Item 1: main launcher
              name = names.exec;
              exec = "${names.exec} %F";
              desktopName = names.long;
              actions.new-empty-window = {
                name = "New Empty Window";
                exec = "${names.exec} --new-window %F";
                icon = names.icon;
              };
            }
            {
              # Item 2: URL handler
              name = "${names.exec}-url-handler";
              exec = "${names.exec} --open-url %U";
              desktopName = "${names.long} - URL Handler";
              # TODO: Confirm this mimeTypes from artifact / upstream
              mimeTypes = [ "x-scheme-handler/${names.icon}" ];
              noDisplay = true;
            }
          ];

        })

        # https://nix.dev/manual/nix/2.28/nix-2.28.html#builtins-map
        # map :: function [items]

        # Merge/update item attrsets into `base` to get complete items
        (data: map (item: data.base // item) data.item-list)

        # Make ${name}.desktop files from both items of the list
        (map makeDesktopItem)
      ];

  # [Long] Description summarised manually from following 3 pages:
  # https://eclipsesource.com/blogs/2018/06/20/welcome-at-eclipse-theia/
  # https://eclipsesource.com/blogs/2024/07/12/vs-code-vs-theia-ide/
  # https://eclipsesource.com/blogs/2023/09/08/eclipse-theia-vs-code-oss/

  meta = {
    description = "Open source, vendor neutral IDE for cloud & desktop, built on Theia Platform";
    longDescription = ''
      An IDE built on the Eclipse Theia platform (hereafter, Theia),
      combining flexibility with modern web technologies (TypeScript, HTML,
      CSS).

      Theia is an open source *platform* for building web- and cloud-based
      *custom* IDEs, domain-specific tools & Eclipse RCP-like applications.
      It supports the Language Server Protocol (LSP), the Debug Adapter
      Protocol (DAP), integrates the Monaco Code Editor (component of VS
      Code), and is compatible with VS Code extension API. It allows much
      deeper customization and adaptability using a second extension
      mechanism, called “Theia extension”, that is not limited to a specific
      API as VS Code extensions are.

      Theia is independently developed with a modular architecture and is
      *not a fork of VS Code*. It is governed by the Eclipse Foundation in a
      vendor neutral way, and driven by a diverse set of long-term
      stakeholders, such as Ericsson, STMicroelectronics, Arm,
      EclipseSource, TypeFox and Red Hat.
    '';
    homepage = "https://theia-ide.org/#theiaide";
    changelog = "https://theia-ide.org/releases/#monthlyreleases";
    downloadPage = "https://theia-ide.org/#theiaidedownload";

    # https://github.com/eclipse-theia/theia-ide/issues/389#issuecomment-2939298127
    license = with lib.licenses; [
      mit
      gpl2Only
      epl20
    ];
    maintainers = with lib.maintainers; [ goyalyashpal ];

    ## Build-related meta information
    mainProgram = "theia-ide";
    # https://github.com/NixOS/nixpkgs/blob/7c43f080a7/pkgs/applications/editors/vscode/vscodium.nix#L80
    # sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # inherit (electron.meta) platforms;
    platforms = [
      # "aarch64-darwin"
      # "aarch64-linux"
      # "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
