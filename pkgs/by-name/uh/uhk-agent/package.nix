{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  electron,
  makeWrapper,
  asar,
  autoPatchelfHook,
  libusb1,
}:

let
  pname = "uhk-agent";
  version = "10.1.0";

  src = fetchurl {
    url = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v${version}/UHK.Agent-${version}-linux-x86_64.AppImage";
    name = "${pname}-${version}.AppImage";
    sha256 = "sha256-44wjTl2zexRbwB9CMHVl6zPQ238DhsCFtf2yaYyXMgg=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  dontUnpack = true;

  nativeBuildInputs = [
    asar
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    libusb1
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{opt,share/applications}

    cp -r --no-preserve=mode "${appimageContents}/resources"        "$out/opt/${pname}"
    cp -r --no-preserve=mode "${appimageContents}/usr/share/icons"  "$out/share/icons"
    cp -r --no-preserve=mode "${appimageContents}/${pname}.desktop" "$out/share/applications/${pname}.desktop"

    substituteInPlace "$out/share/applications/${pname}.desktop" \
      --replace "Exec=AppRun" "Exec=${pname}"

    asar extract "$out/opt/${pname}/app.asar" "$out/opt/${pname}/app.asar.unpacked"
    rm           "$out/opt/${pname}/app.asar"

    makeWrapper "${electron}/bin/electron" "$out/bin/${pname}" \
      --add-flags "$out/opt/${pname}/app.asar.unpacked" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  # SmartMacroCopy fs.cp's bundled docs out of the nix store (dirs mode 0555)
  # into ~/.config/uhk-agent/smart-macro-docs, preserving source modes. Inside
  # the minified SmartMacroCopy (Mi) the sequence is:
  #   1. fs.cp(firmware/doc -> dest)               # creates dest as 0555
  #   2. fs.cp(firmware/doc-dev -> dest/doc-dev)   # needs write on dest
  #   3. (later) chmod -R +w smart-macro-docs
  # Step 2 fails with EACCES on first launch; step 1's force-unlink fails on
  # every subsequent launch against the leftover 0555 tree. The unhandled
  # rejection aborts createWindow, leaving a live process with no window.
  #
  # Upstream fix: https://github.com/UltimateHackingKeyboard/agent/pull/3024
  # (Vi is the existing makeFolderWriteableToUserOnLinux helper, hoisted).
  # Drop this postFixup once a release containing that fix is packaged.
  postFixup = ''
    substituteInPlace $out/opt/${pname}/app.asar.unpacked/electron-main.js \
      --replace-fail \
        'await(0,Pi.cp)(s,i,{force:!0,recursive:!0});const a=g().join(e.tmpDirectory,"doc-dev"),c=g().join(i,"doc-dev");await(0,Pi.cp)(a,c,{force:!0,recursive:!0}),t.misc("[SmartMacroCopy] done")' \
        'await Vi(i).catch(()=>{}),await(0,Pi.cp)(s,i,{force:!0,recursive:!0}),await Vi(i);const a=g().join(e.tmpDirectory,"doc-dev"),c=g().join(i,"doc-dev");await(0,Pi.cp)(a,c,{force:!0,recursive:!0}),t.misc("[SmartMacroCopy] done")'
    wrapProgram $out/bin/${pname} --run '
      docs="''${XDG_CONFIG_HOME:-$HOME/.config}/uhk-agent/smart-macro-docs"
      [ -d "$docs" ] && chmod -R u+w "$docs" || true
    '
  '';

  meta = {
    description = "Configuration application of the Ultimate Hacking Keyboard";
    homepage = "https://github.com/UltimateHackingKeyboard/agent";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [
      nickcao
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
