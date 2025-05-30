{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  makeWrapper,
  nodejs,
  writableTmpDirAsHomeHook,
  stdenv,
  yarn,
}:

stdenv.mkDerivation rec {
  pname = "yaml-language-server";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "yaml-language-server";
    tag = version;
    hash = "sha256-YGPktMZxYi6eihCDc8JIfN/Ht2uu3wGKoKPJWlDKu+g=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-2OVxvvijnfB8Bytgoaybyx4p66nD/aahtyjxLf8womE=";
  };

  nativeBuildInputs = [
    makeWrapper
    fixup-yarn-lock
    yarn
    nodejs
    writableTmpDirAsHomeHook
  ];

  # NodeJS is also needed here so that script interpreter get patched
  buildInputs = [ nodejs ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline compile
    yarn --offline build:libs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p $out/bin $out/lib/node_modules/yaml-language-server
    cp -r . $out/lib/node_modules/yaml-language-server
    ln -s $out/lib/node_modules/yaml-language-server/bin/yaml-language-server $out/bin/

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/redhat-developer/yaml-language-server/blob/${src.rev}/CHANGELOG.md";
    description = "Language Server for YAML Files";
    homepage = "https://github.com/redhat-developer/yaml-language-server";
    license = lib.licenses.mit;
    mainProgram = "yaml-language-server";
    maintainers = [ ];
  };
}
