{
  stdenv,
  lib,
  fetchzip,
  dpkg,
  makeWrapper,
  callPackage,
  addDriverRunpath,
  electron,
  withTetrioPlus ? false,
  tetrio-plus ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tetrio-desktop";
  version = "9.0.0";

  src = fetchzip {
    url = "https://tetr.io/about/desktop/builds/${lib.versions.major finalAttrs.version}/TETR.IO%20Setup.deb";
    hash = "sha256-TgegFy+sHjv0ILaiLO1ghyUhKXoj8v43ACJOJhKyI0c=";
    nativeBuildInputs = [ dpkg ];
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase =
    let
      tetrio-plus' =
        if tetrio-plus == null then
          callPackage ./tetrio-plus.nix {
            tetrio-src = finalAttrs.src;
            tetrio-version = finalAttrs.version;
          }
        else
          tetrio-plus;

      asarPath = if withTetrioPlus then "${tetrio-plus'}/app.asar" else "opt/TETR.IO/resources/app.asar";
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

  postFixup = ''
    makeShellWrapper '${lib.getExe electron}' $out/bin/tetrio \
      --prefix LD_LIBRARY_PATH : ${addDriverRunpath.driverLink}/lib \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags $out/share/TETR.IO/app.asar
  '';

  meta = {
    changelog = "https://tetr.io/about/desktop/history/";
    description = "TETR.IO desktop client";
    downloadPage = "https://tetr.io/about/desktop/";
    homepage = "https://tetr.io";
    license = lib.licenses.unfree;
    longDescription = ''
      TETR.IO is a modern yet familiar online stacker.
      Play against friends and foes all over the world, or claim a spot on the leaderboards - the stacker future is yours!
    '';
    mainProgram = "tetrio";
    maintainers = with lib.maintainers; [
      wackbyte
      huantian
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
