{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "wanderer";
  version = "0.20.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "open-wanderer";
    repo = "wanderer";
    rev = "v${version}";
    hash = "sha256-Z4oKOf8bLyoYqjsg/bWWc8GYai2ZUYISFBiu4AHGexY=";
  };

  sourceRoot = "${src.name}/web";

  npmDepsHash = "sha256-G+Ozwt8ir2StIFU/I4cMF77alNkW4sp28WJeTnBnBFk=";
  inherit nodejs;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wanderer
    cp -r build package.json node_modules $out/share/wanderer/

    makeWrapper ${nodejs}/bin/node $out/bin/wanderer \
      --chdir "$out/share/wanderer" \
      --add-flags "$out/share/wanderer/build/index.js"

    runHook postInstall
  '';

  meta = {
    description = "Web interface for Wanderer trail database";
    homepage = "https://github.com/open-wanderer/wanderer";
    license = lib.licenses.agpl3Only;
    mainProgram = "wanderer";
    maintainers = with lib.maintainers; [ maartenbehn ];
    platforms = lib.platforms.unix;
  };
}
