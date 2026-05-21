{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
}:

buildNpmPackage rec {
  pname = "twig-language-server";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kaermorchen";
    repo = "twig-language-server";
    tag = "v${version}";
    hash = "sha256-GoLGlfvHQYD7fdE+kTobqxqtekrhmVD0Q560rVt/1MY=";
  };

  npmDepsHash = "sha256-q4/+8bG3HQgh8r7IJbinf/muvwaPFa+k7CmHKvVou28=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib}
    cp -R node_modules packages $out/lib
    makeWrapper ${lib.getExe nodejs} $out/bin/twig-language-server \
      --inherit-argv0 \
      --prefix NODE_PATH : $out/lib/node_modules \
      --add-flags $out/lib/packages/language-server/out/index.js
    runHook postInstall
  '';
  meta = {
    description = "Language server for Twig templates";
    homepage = "https://github.com/kaermorchen/twig-language-server";
    changelog = "https://github.com/kaermorchen/twig-language-server/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "twig-language-server";
  };
}
