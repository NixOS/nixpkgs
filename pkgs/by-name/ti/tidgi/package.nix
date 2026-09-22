{
  lib,
  stdenv,
  fetchurl,
  unzip,
  writeShellScript,
  jq,
  ast-grep,
  common-updater-scripts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tidgi";
  version = "0.12.4";

  src = fetchurl {
    url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${finalAttrs.version}/TidGi-darwin-arm64-${finalAttrs.version}.zip";
    hash = "sha256-bSJFM67+KVECUqjwu1HYipn+zOps1ahNzM721yZL52c=";
  };

  dontBuild = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-tidgi" ''
    version=$(nix eval --raw --file . tidgi.version)
    latestVersion=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/tiddly-gittly/TidGi-Desktop/releases/latest | ${lib.getExe jq} --raw-output .tag_name | sed 's/^v//')
    if [[ "$latestVersion" == "$version" ]]; then
      exit 0
    fi
    ${lib.getExe ast-grep} scan --inline-rules "
    id: update-version
    language: nix
    rule:
      kind: binding
      regex: '^\s*version\s*='
    fix: 'version = \"$latestVersion\";'
    " --update-all $(env EDITOR=echo nix edit --file . tidgi)
    ${lib.getExe' common-updater-scripts "update-source-version"} tidgi $latestVersion --ignore-same-version --ignore-same-hash
    done
  '';

  meta = {
    changelog = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/tag/v${finalAttrs.version}";
    description = "Customizable personal knowledge-base and blogging platform with git as backup manager";
    homepage = "https://github.com/tiddly-gittly/TidGi-Desktop";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ klchen0112 ];
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
