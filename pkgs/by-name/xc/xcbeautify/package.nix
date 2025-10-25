{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  unzip,
  writeShellScript,
  jq,
  common-updater-scripts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcbeautify";
  version = "2.30.1";

  src =
    let
      cpu =
        {
          x86_64 = "x86_64";
          aarch64 = "arm64";
        }
        .${stdenv.hostPlatform.parsed.cpu.name}
          or (throw "Unsupported cpu: ${stdenv.hostPlatform.parsed.cpu.name}");
    in
    fetchurl {
      url = "https://github.com/cpisciotta/xcbeautify/releases/download/${finalAttrs.version}/xcbeautify-${finalAttrs.version}-${cpu}-apple-macosx.zip";
      hash =
        {
          x86_64-darwin = "sha256-6Qx6gf4MnbIWJU/Kda2TB50dUnFYNrjm2BK6/PVEYHc=";
          aarch64-darwin = "sha256-L39PjvJ3bRs5CIXzwJ0KFEcFGzZqoFzwPd1sjBrt27w=";
        }
        .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    };

  nativeBuildInputs = [
    installShellFiles
    unzip
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    installBin xcbeautify

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-xcbeautify" ''
    version=$(nix eval --raw --file . xcbeautify.version)
    latestVersion=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/cpisciotta/xcbeautify/releases/latest | ${lib.getExe jq} --raw-output .tag_name)
    if [[ "$latestVersion" == "$version" ]]; then
      exit 0
    fi
    ${lib.getExe' common-updater-scripts "update-source-version"} xcbeautify $latestVersion $(nix eval --raw --file . lib.fakeHash) --system=aarch64-darwin || true
    systems=$(nix eval --json -f . xcbeautify.meta.platforms | ${lib.getExe jq} --raw-output '.[]')
    for system in $systems; do
      hash=$(nix hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw --file . xcbeautify.src.url --system "$system")))
      ${lib.getExe' common-updater-scripts "update-source-version"} xcbeautify $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
    done
  '';

  meta = {
    description = "Little beautifier tool for xcodebuild";
    homepage = "https://github.com/cpisciotta/xcbeautify";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "xcbeautify";
    maintainers = with lib.maintainers; [ siddarthkay ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
