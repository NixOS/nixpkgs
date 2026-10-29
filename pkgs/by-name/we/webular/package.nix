{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  sources = {
    aarch64-darwin = {
      asset = "darwin-arm64";
      hash = "sha256-rdDD5TbRiXmi9zBhfm3xPCUEK3MnmTnacllV92yncp8=";
    };
    x86_64-darwin = {
      asset = "darwin-x64";
      hash = "sha256-lwxNMs6AVJ50cN6Ov4zAR4NSyAoM5E9t+tkBfzW3v4Q=";
    };
    x86_64-linux = {
      asset = "linux-x64";
      hash = "sha256-RyX0mV9HHtTj5HQOQ1M/A+dWEUc60a7x0EBvJgNh3HA=";
    };
    aarch64-linux = {
      asset = "linux-arm64";
      hash = "sha256-uB1SOmC0UduzaUin6jJY4cqWE3jPpGQnFcS7x6gruE4=";
    };
  };
  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "webular: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "webular";
  version = "0.3.2";

  src = fetchurl {
    url = "https://github.com/srinitude/webular/releases/download/v${finalAttrs.version}/webular-${source.asset}";
    inherit (source) hash;
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;
  # The executable is a Bun single-file build; stripping drops its embedded payload.
  dontStrip = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/webular
    runHook postInstall
  '';

  meta = {
    description = "Universal web research CLI";
    homepage = "https://github.com/srinitude/webular";
    changelog = "https://github.com/srinitude/webular/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ srinitude ];
    mainProgram = "webular";
    platforms = builtins.attrNames sources;
  };
})
