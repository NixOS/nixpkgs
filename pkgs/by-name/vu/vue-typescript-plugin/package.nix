{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "vue-typescript-plugin";
  version = "2.0.29";

  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/typescript-plugin/-/typescript-plugin-${version}.tgz";
    hash = "sha256-yaUb3Wl1bMA46oK+vH/QPh+F5qRTCmdqPHgBNfrkuyk=";
  };

  npmDepsHash = "sha256-gKX2Fc54BKA16lWIRNkcdr11Cvy2NqztPb3HKw9NzB8=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    description = "Typescript plugin for the Vue.js language server";
    homepage = "https://github.com/vuejs/language-tools#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uncl0g ];
  };
}
