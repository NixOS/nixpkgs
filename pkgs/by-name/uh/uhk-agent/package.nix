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
<<<<<<< HEAD
  version = "9.0.0";
=======
  version = "8.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchurl {
    url = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v${version}/UHK.Agent-${version}-linux-x86_64.AppImage";
    name = "${pname}-${version}.AppImage";
<<<<<<< HEAD
    sha256 = "sha256-QMs4xCXOuxDNlWcprUsb/+RvTcW83nkUcoH9/Oi0OYY=";
=======
    sha256 = "sha256-3oyVz+DG35YlUwsMhp80QRm67FBsLRj0tQXjZH9asI8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Configuration application of the Ultimate Hacking Keyboard";
    homepage = "https://github.com/UltimateHackingKeyboard/agent";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Configuration application of the Ultimate Hacking Keyboard";
    homepage = "https://github.com/UltimateHackingKeyboard/agent";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [
      ngiger
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      nickcao
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
