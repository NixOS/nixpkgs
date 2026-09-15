{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
}:

let
  pname = "zcode";
  version = "3.11.2";

  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x64";

  src = fetchurl {
    url = "https://cdn-zcode.z.ai/zcode/electron/releases/${version}/linux-${arch}/ZCode-${version}-linux-${arch}.AppImage";
    hash =
      if stdenv.hostPlatform.isAarch64
      then "sha512-GdiCqfNajvQbiWtMIAJoI17f2GEOpsfWcFU0OZ/BpE8ql2in1TA71RN0l8KIglqIlQHQtKyEpTZ7H927MvSapQ=="
      else "sha512-XKRHuVwrelpCtJADnH4TlUuU2HBhDTRjDUbR+8/lYAFmovEjqMXWiZ6GdxC3I21+IveW9WpknR2vwANkh/1IHg==";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
    # Point the desktop entry at the wrapped binary and keep upstream's
    # --no-sandbox launch (matches the shipped AppRun invocation).
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' "Exec=$out/bin/${pname} --no-sandbox %U"
  '';

  meta = with lib; {
    description = "Agentic, multi-agent vibe-coding desktop app by Z.AI (official harness for GLM-5)";
    longDescription = ''
      ZCode is Z.AI's next-generation "vibe coding" desktop app for complex,
      multi-agent development goals. It is the official harness for the GLM
      family of coding models and supports running and controlling multiple
      agents from anywhere.
    '';
    homepage = "https://zcode.z.ai";
    downloadPage = "https://zcode.z.ai/en";
    changelog = "https://zcode.z.ai/en/changelog";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with lib.maintainers; [ perryh ];
    mainProgram = pname;
  };
}
