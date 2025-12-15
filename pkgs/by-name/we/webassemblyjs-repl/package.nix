{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  makeBinaryWrapper,
  gcc,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "webassemblyjs-repl";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "xtuc";
    repo = "webassemblyjs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zkZyI/bLSCZkgSEH9kx8Qls7RZuiTVP5CwWlFaK1yI8=";
  };

  postPatch = ''
    substituteInPlace packages/**/package.json \
      --replace-warn "1.13.2" "1.14.1"

    patchShebangs scripts/
  '';

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-gweiisUVp1D4BAcyuf3V81jN+ehm6z5ztftG+tc7M+A=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ gcc ];

  preInstall = ''
    yarn install --offline --prod --no-bin-links
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/{packages,node_modules}
    mkdir $out/bin
    mv -t $out/lib/packages packages/**
    mv -t $out/lib/node_modules node_modules/**

    makeWrapper ${lib.getExe nodejs} $out/bin/wasm \
      --add-flags "$out/lib/packages/repl/lib/bin.js" \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WebAssembly REPL";
    homepage = "https://webassembly.js.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "wasm";
  };
})
