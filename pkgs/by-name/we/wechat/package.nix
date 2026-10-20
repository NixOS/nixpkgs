{
  lib,
  stdenvNoCC,
  callPackage,
  fetchurl,
}:

let
  inherit (stdenvNoCC.hostPlatform) system isDarwin;

  sources = lib.importJSON ./sources.json;
  source = sources.${system} or (throw "Unsupported system: ${system}");

  pname = "wechat";
  meta = {
    description = "Messaging and calling app";
    homepage = "https://www.wechat.com/en/";
    downloadPage = "https://linux.weixin.qq.com/en";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      larry0x
      moraxyc
      prince213
    ];
    mainProgram = "wechat";
    platforms = lib.attrNames sources;
  };

in
callPackage (if isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname meta;
  inherit (source) version;
  src =
    if isDarwin then
      fetchurl source.src
    else
      # Try upstream first as Wayback Machine is slow in China (where most users are located)
      fetchurl {
        inherit (source.src) url hash;
        netrcPhase = ''
          touch netrc

          url=${lib.escapeShellArg source.upstream.url}
          crc=${lib.escapeShellArg source.upstream."x-cos-hash-crc64ecma"}
          ver=${lib.escapeShellArg source.upstream."x-cos-version-id"}

          if actual=$(curl -fsSIL -o /dev/null -w '%header{x-cos-hash-crc64ecma}:%header{x-cos-version-id}' "$url") && [[ "$actual" == "$crc:$ver" ]]; then
            urls=("$url")
          fi
        '';
      };
  passthru = {
    updateScript = ./update.py;
  };
}
