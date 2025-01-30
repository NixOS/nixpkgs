{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "zotero-translation-server";
  version = "unstable-2023-07-13";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "translation-server";
    rev = "cf96d57f4e2af66fee7df9bad00681b3f4ac7d77";
    hash = "sha256-GJn7UAl0raVGzplvFzo4A0RUjNbyGt/YI2mt1UZIJv0=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-JHoBxUybs1GGRxEVG5GgX2mOCplTgR5dcPjnR42SEbY=";

  makeCacheWritable = true;

  dontNpmBuild = true;

  postInstall = ''
    mkdir -p $out/bin/ $out/share/zotero-translation-server/
    makeWrapper ${nodejs}/bin/node $out/bin/translation-server \
      --add-flags "$out/lib/node_modules/translation-server/src/server.js"
    ln -s $out/lib/node_modules/translation-server/config $out/share/zotero-translation-server/config
    ln -s $out/lib/node_modules/translation-server/modules $out/share/zotero-translation-server/modules
  '';

  meta = with lib; {
    description = "Node.js-based server to run Zotero translators";
    homepage = "https://github.com/zotero/translation-server";
    license = licenses.agpl3Only;
    maintainers = [ ];
    mainProgram = "translation-server";
  };
}
