{
  lib,
  stdenv,
  bun,
  nodejs,
  git,
  yubal,
}:

let
  node_modules = stdenv.mkDerivation {
    inherit (yubal) version;
    pname = yubal.pname + "-web-node_modules";
    nativeBuildInputs = [
      bun
      nodejs
    ];
    phases = [
      "buildPhase"
      "installPhase"
    ];

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    buildPhase = ''
      cp ${yubal.src}/web/package.json package.json
      cp ${yubal.src}/web/bun.lock bun.lock
      bun install --no-progress --frozen-lockfile
    '';

    installPhase = ''
      mkdir -p $out/node_modules
      cp -R node_modules/. $out/node_modules/
    '';

    outputHash =
      {
        x86_64-linux = "sha256-JKgSEtkqopgRPEZ1eUFSoepFFFabHeJ5VJIMjdmVxpU=";
        aarch64-linux = "sha256-pJMpSfF481aF9+3VzLOILGTwMzqX+AiIsrOnC0nI3X0=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in

stdenv.mkDerivation {
  inherit (yubal) version src;
  pname = yubal.pname + "-web";
  buildInputs = [
    bun
    nodejs
    git
  ];
  sourceRoot = "source/web";

  buildPhase = ''
    mkdir -p node_modules
    cp -R ${node_modules}/node_modules/. node_modules/
    patchShebangs node_modules
    bun run build
  '';

  installPhase = ''
    mkdir -p $out/dist
    cp -r dist/* $out/dist/
  '';
}
