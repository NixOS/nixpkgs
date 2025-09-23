{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  jq,
  nixosTests,
  nix-update-script,
}:

let
  packageBin = builtins.toJSON {
    bin.wiki-js = "server";
  };
  extractFilesPackageFix = builtins.toJSON {
    exports = {
      "./public/extractFiles" = "./public/extractFiles.js";
      "./public/isExtractableFile" = "./public/isExtractableFile.js";
      "./public/ReactNativeFile" = "./public/ReactNativeFile.js";
    };
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wiki-js";
  version = "2.5.308";

  src = fetchFromGitHub {
    owner = "requarks";
    repo = "wiki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WD5R9ujoUR5K1p460tuFp/ZKvJxNSh0/B/S7R2VV5hI=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-iFQXQV0uqIi2MfSNOHwY8YvBSb9mMGEY8bZ5CzGbiqE=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
    jq
  ];

  # As so often with node projects, this ends up taking ages for no benefit in size.
  dontStrip = true;

  # The yarnInstallHook takes care of wrapping for us, but only if package.json defines binaries.
  preInstall = ''
    mv package.json{,.orig}
    jq '. + ${packageBin}' package.json.orig > package.json
  '';

  # See https://github.com/requarks/wiki/discussions/5113
  postFixup = ''
    pushd $out/lib/node_modules/wiki/node_modules/extract-files
    mv package.json{,.orig}
    jq '. * ${extractFilesPackageFix}' package.json.orig > package.json
    popd
  '';

  passthru = {
    tests = { inherit (nixosTests) wiki-js; };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://js.wiki/";
    description = "Modern and powerful wiki app built on Node.js";
    mainProgram = "wiki-js";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ niklaskorz ];
  };
})
