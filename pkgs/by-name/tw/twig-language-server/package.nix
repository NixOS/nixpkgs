{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
}:

buildNpmPackage rec {
  pname = "twig-language-server";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "kaermorchen";
    repo = "twig-language-server";
    tag = "v${version}";
    hash = "sha256-Jwi1+s2+TC656rXOukjLS4w1Y9VxwEdAe0y5Q3Iz0LA=";
  };

  npmDepsHash = "sha256-8M0CouDu3rjD3xGx5bheTG9pyN7Qe+O9FeTFZPmr+Mo=";

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
