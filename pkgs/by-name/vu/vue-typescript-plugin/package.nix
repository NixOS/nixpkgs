{
  lib,
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "vue-typescript-plugin";
  version = "2.2.0";
  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/typescript-plugin/-/typescript-plugin-${version}.tgz";
    hash = "sha256-WzbJ3ERFZ4T22RNSYXAVTWb+6Q3WEPYimFzkugNao+4=";
  };
  npmDepsHash = "sha256-yzoeV5ZRvRu1ADdGJ9DdolWOQvGF+FIdn5J5G/KItk4=";
  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';
  dontNpmBuild = true;
  passthru.updateScript = ./update.sh;
  meta = {
    description = "Official Vue.js typescript plugin";
    homepage = "https://github.com/vuejs/language-tools#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wbondanza_devoteam ];
    mainProgram = "vue-typescript-plugin";
  };
}
