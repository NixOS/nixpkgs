{
  stdenv,
  lib,
  fetchzip,
  fetchurl,
  dpkg,
  makeWrapper,
  addDriverRunpath,
  electron,
  _7zz,
  withTetrioPlus ? false,
  tetrio-plus,
}:

let
  inherit (stdenv.hostPlatform) isDarwin system;

  version = "10";

  srcs = {
    x86_64-linux = fetchzip {
      url = "https://tetr.io/about/desktop/builds/${version}/TETR.IO%20Setup.deb";
      hash = "sha256-2FtFCajNEj7O8DGangDecs2yeKbufYLx1aZb3ShnYvw=";
      nativeBuildInputs = [ dpkg ];
    };
    aarch64-darwin = fetchurl {
      url = "https://tetr.io/about/desktop/builds/${version}/TETR.IO%20Setup%20arm64.dmg";
      hash = "sha256-PbK9XEynpii35p6DQYiPbaRM4guPazWd5N4Dr2O4H24=";
    };
    x86_64-darwin = fetchurl {
      url = "https://tetr.io/about/desktop/builds/${version}/TETR.IO%20Setup%20x86.dmg";
      hash = "sha256-I4Mj6YY7KwpLk2tZ02EdqUxnxSW/3vCM4J7YFzCLEuM=";
    };
  };
in
stdenv.mkDerivation {
  pname = "tetrio-desktop";
  inherit version;

  src = srcs.${system} or (throw "Unsupported system: ${system}");

  nativeBuildInputs = lib.optionals (!isDarwin) [ makeWrapper ] ++ lib.optionals isDarwin [ _7zz ];

  sourceRoot = lib.optionalString isDarwin "TETR.IO.app";

  unpackPhase = lib.optionalString isDarwin ''
    7zz x $src
  '';

  installPhase =
    if isDarwin then
      ''
        runHook preInstall

        mkdir -p "$out/Applications/TETR.IO.app"
        cp -R . "$out/Applications/TETR.IO.app"

        ${lib.optionalString withTetrioPlus ''
          cp ${tetrio-plus} "$out/Applications/TETR.IO.app/Contents/Resources/app.asar"
        ''}

        runHook postInstall
      ''
    else
      let
        asarPath = if withTetrioPlus then tetrio-plus else "opt/TETR.IO/resources/app.asar";
      in
      ''
        runHook preInstall

        mkdir -p $out
        cp -r usr/share/ $out

        mkdir -p $out/share/TETR.IO/
        cp ${asarPath} $out/share/TETR.IO/app.asar

        substituteInPlace $out/share/applications/TETR.IO.desktop \
          --replace-fail "Exec=/opt/TETR.IO/TETR.IO" "Exec=$out/bin/tetrio"

        runHook postInstall
      '';

  postFixup = lib.optionalString (!isDarwin) ''
    makeShellWrapper '${lib.getExe electron}' $out/bin/tetrio \
      --prefix LD_LIBRARY_PATH : ${addDriverRunpath.driverLink}/lib \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags $out/share/TETR.IO/app.asar
  '';

  meta = {
    changelog = "https://tetr.io/about/desktop/history/";
    description = "Desktop client for TETR.IO, an online stacker game";
    downloadPage = "https://tetr.io/about/desktop/";
    homepage = "https://tetr.io";
    license = lib.licenses.unfree;
    longDescription = ''
      TETR.IO is a free-to-win modern yet familiar online stacker.
      Play multiplayer games against friends and foes all over the world, or claim a spot on the leaderboards - the stacker future is yours!
    '';
    mainProgram = "tetrio";
    maintainers = with lib.maintainers; [
      huantian
      anish
    ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
