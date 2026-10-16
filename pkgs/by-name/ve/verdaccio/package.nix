{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_3,
  makeWrapper,
}:
let
  yarn-berry = yarn-berry_3;
in

stdenv.mkDerivation (finalAttrs: rec {
  pname = "verdaccio";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "verdaccio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EssvN5HtGI5Hmw4EXetj5nzrkBZAAJGgOx09dlYJzhI=";
  };

  nativeBuildInputs = [
    makeWrapper
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-jzkmDxQtIFMa1LIPcvKKsXIItPntgXTavoWhd5eZWyQ=";
  };

  buildPhase = ''
    runHook preBuild

    yarn install
    yarn run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r . $out/share/verdaccio

     # PnP based packages need `yarn node` instead of `node` to run binaries
    makeWrapper ${lib.getExe yarn-berry} "$out/bin/verdaccio" \
      --chdir "$out/share/verdaccio" \
      --add-flags "node ./bin/verdaccio"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple, zero-config-required local private npm registry";
    longDescription = ''
      Verdaccio is a simple, zero-config-required local private npm registry. No need for an entire database just to get started! Verdaccio comes out of the box with its own tiny database, and the ability to proxy other registries (eg. npmjs.org), caching the downloaded modules along the way. For those looking to extend their storage capabilities, Verdaccio supports various community-made plugins to hook into services such as Amazon's s3, Google Cloud Storage or create your own plugin.
    '';
    homepage = "https://verdaccio.org";
    license = licenses.mit;
  };
})
