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
  pname = "webassemblyjs-cli";
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

    declare -a cmds=("wasmdump" "wasmast" "wasmrun"
                    "wasm2wast" "wastast" "get-producer-section"
                    "wast-to-wasm-semantics")
    for c in "''${cmds[@]}"
    do
      makeWrapper ${lib.getExe nodejs} $out/bin/$c \
        --add-flags "$out/lib/packages/cli/lib/$c.js" \
        --set NODE_PATH "$out/lib/node_modules"
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Toolbox for WebAssembly";
    homepage = "https://webassembly.js.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
