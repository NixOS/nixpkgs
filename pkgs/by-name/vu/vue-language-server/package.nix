{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "vue-language-server";
  version = "3.0.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/language-server/-/language-server-${version}.tgz";
    hash = "sha256-kSJgE94O1qYdd/YoRex8CJSprS15PpboTzChKnYj2nE=";
  };

  npmDepsHash = "sha256-S1kmTeReoAn428HaHQbwFzQg75rQNFVKVT1HT9m+7K4=";
  forceGitDeps = true;

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;
  makeCacheWritable = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Official Vue.js language server";
    homepage = "https://github.com/vuejs/language-tools#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ friedow ];
    mainProgram = "vue-language-server";
  };
}
