{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "vue-language-server";
  version = "3.0.0-alpha.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/language-server/-/language-server-${version}.tgz";
    hash = "sha256-YXk4Io/JlqknsVDYZVWqvRQygrJ0iLBvYl1RwcYobS4=";
  };

  npmDepsHash = "sha256-caMg7ROS/XKv6fZ7/OMl7DIRYWcaSZ8UeHFr2kw4+BE=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

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
