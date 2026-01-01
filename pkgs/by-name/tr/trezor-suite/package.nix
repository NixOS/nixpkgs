{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  tor,
  trezord,
}:

let
  pname = "trezor-suite";
<<<<<<< HEAD
  version = "25.12.2";
=======
  version = "25.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  suffix =
    {
      aarch64-linux = "linux-arm64";
      x86_64-linux = "linux-x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/trezor/trezor-suite/releases/download/v${version}/Trezor-Suite-${version}-${suffix}.AppImage";
    hash =
      {
        # curl -Lfs https://github.com/trezor/trezor-suite/releases/download/v${version}/latest-linux{-arm64,}.yml | grep ^sha512 | sed 's/: /-/'
<<<<<<< HEAD
        aarch64-linux = "sha512-AneflaNO3OXomrhwiCQC0bw1hvFVVWy9YQ63zmeAAU5YQYFRhdlvXXNCxQEFKXfy6079MvLM67+42FGGsVAf6w==";
        x86_64-linux = "sha512-/kjqLGF7MY+2UGSE7DnS64o8U2HntzGrw3c5b5AGoXc8wx3emEBjPmTELnDxQpgMdl7L7uaV3O1Sj2ebfweRpQ==";
=======
        aarch64-linux = "sha512-y+nUowpLmE7yIE3VeWzD/cnnL+o65/fK4W8/IhZKf02V2LoGUipwdZMnQ4xRVY/GVbzmk06qmrAiA7pxRAIEpA==";
        x86_64-linux = "sha512-8eZSx5ZOjjJKXxINfMSIbxA+y4RiXd9V87wWaDv687Dl+EYdcAGVWnce2rDneXd2QuKYazfR+QOQcDEhHqP/+A==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

in

appimageTools.wrapType2 rec {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    mkdir -p $out/bin $out/share/${pname} $out/share/${pname}/resources

    cp -a ${appimageContents}/locales/ $out/share/${pname}
    cp -a ${appimageContents}/resources/app*.* $out/share/${pname}/resources
    cp -a ${appimageContents}/resources/images/ $out/share/${pname}/resources

    wrapProgram $out/bin/trezor-suite \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/resources/images/desktop/512x512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'

    # symlink system binaries instead bundled ones
    mkdir -p $out/share/${pname}/resources/bin/{bridge,tor}
    ln -sf ${trezord}/bin/trezord-go $out/share/${pname}/resources/bin/bridge/trezord
    ln -sf ${tor}/bin/tor $out/share/${pname}/resources/bin/tor/tor
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Trezor Suite - Desktop App for managing crypto";
    homepage = "https://suite.trezor.io";
    changelog = "https://github.com/trezor/trezor-suite/releases/tag/v${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "trezor-suite";
  };
}
