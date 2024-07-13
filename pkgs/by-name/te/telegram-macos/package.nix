{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  makeWrapper,
  gnused,
  darwin,
}:
let
  version = "10.15.2-265540";
  versionTokens = lib.split "-" version;
  versionFirst = lib.head versionTokens;
  versionSecond = lib.last versionTokens;
  sigtool = darwin.sigtool.overrideAttrs (old: {
    # this is a fork of sigtool that supports -v and --remove-signature
    # As seen in dotnet derivation:
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/dotnet/sigtool.nix
    src = fetchFromGitHub {
      owner = "corngood";
      repo = "sigtool";
      rev = "new-commands";
      sha256 = "sha256-EVM5ZG3sAHrIXuWrnqA9/4pDkJOpWCeBUl5fh0mkK4k=";
    };

    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ makeWrapper ];

    postInstall =
      old.postInstall or ""
      + ''
        wrapProgram $out/bin/codesign \
          --set-default CODESIGN_ALLOCATE \
            "${darwin.cctools}/bin/${darwin.cctools.targetPrefix}codesign_allocate"
      '';
  });
in
stdenvNoCC.mkDerivation {
  inherit version;

  pname = "telegram-macos";

  src = fetchzip {
    url = "https://osx.telegram.org/updates/Telegram-${versionFirst}.${versionSecond}.app.zip";
    hash = "sha256-9eWx1vTDyWdlJ8mAFqj06T7P6VWbU0AwOFHm4aQfyCw=";
    stripRoot = false;
  };

  dontBuild = true;

  nativeBuildInputs = [
    gnused
    sigtool
  ];

  patchPhase = ''
    runHook prePatch

    # Disable Sparkle auto-update feature
    # https://sparkle-project.org/documentation/customization/

    plist_file="Telegram.app/Contents/Info.plist"

    sed '$d' $plist_file | sed '$d' > temp.plist

    cat <<EOF >> temp.plist
            <key>SUAllowsAutomaticUpdates</key>
            <false/>
            <key>SUEnableAutomaticChecks</key>
            <false/>
    </dict>
    </plist>
    EOF

    mv temp.plist $plist_file

    # Remove signature

    codesign --remove-signature Telegram.app/Contents/MacOS/Telegram

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r Telegram.app $out/Applications
    runHook postInstall
  '';

  meta = {
    description = "Telegram client for macOS, written in Swift";
    homepage = "https://macos.telegram.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
