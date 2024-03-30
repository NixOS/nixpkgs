{ stdenv
, lib
, fetchurl
, dpkg
, makeWrapper
, addOpenGLRunpath
, electron
, withTetrioPlus ? false # For backwards compatibility. At the time of writing, the latest released tetrio plus version is not compatible with tetrio desktop.
, tetrio-plus ? false # For backwards compatibility. At the time of writing, the latest released tetrio plus version is not compatible with tetrio desktop.
}:

lib.warnIf (withTetrioPlus != false) "withTetrioPlus: Currently unsupported with tetrio-desktop 9.0.0. Please remove this attribute."
lib.warnIf (tetrio-plus != false) "tetrio-plus: Currently unsupported with tetrio-desktop 9.0.0. Please remove this attribute."

stdenv.mkDerivation (finalAttrs: {
  pname = "tetrio-desktop";
  version = "9.0.0";

  src = fetchurl {
    url = "https://tetr.io/about/desktop/builds/${lib.versions.major finalAttrs.version}/TETR.IO%20Setup.deb";
    hash = "sha256-UriLwMB8D+/T32H4rPbkJAy/F/FFhNpd++0AR1lwEfs=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/share/ $out

    mkdir -p $out/share/TETR.IO/
    cp opt/TETR.IO/resources/app.asar $out/share/TETR.IO/app.asar

    substituteInPlace $out/share/applications/TETR.IO.desktop \
      --replace-fail "Exec=/opt/TETR.IO/TETR.IO" "Exec=$out/bin/tetrio"

    runHook postInstall
  '';

  postFixup = ''
    makeShellWrapper '${lib.getExe electron}' $out/bin/tetrio \
      --prefix LD_LIBRARY_PATH : ${addOpenGLRunpath.driverLink}/lib \
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
    maintainers = with lib.maintainers; [ wackbyte huantian ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
