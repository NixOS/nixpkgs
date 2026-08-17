{
  lib,
  fetchFromGitLab,
  rustPlatform,
  rustc,
  binaryen,
}:

rustPlatform.buildRustPackage {
  pname = "tpsecore";
  version = "0.1.1-unstable-2026-04-06";

  src = fetchFromGitLab {
    owner = "UniQMG";
    repo = "tpsecore";
    rev = "549767cac60df6f887f6012fa5d26ca12d55a2eb";
    hash = "sha256-nnekiqs9W7oOl0/yjuQI83MsRgRZRrgipnwIbhRdLW8=";
  };

  cargoHash = "sha256-rJDy0gbtIGM5q6w0tfgIE09HW1lQ9pEL9o+LSdX6RyU=";

  nativeBuildInputs = [
    binaryen
    rustc.llvmPackages.lld
  ];

  buildPhase = ''
    runHook preBuild

    HOME=$(mktemp -d) cargo build --profile release \
    --target wasm32-unknown-unknown --features wasm_rendering

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp target/wasm32-unknown-unknown/release/tpsecore.wasm $out/
    cp tpsecore.js $out/

    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "Self contained toolkit for creating, editing, and previewing TPSE files";
    homepage = "https://gitlab.com/UniQMG/tpsecore";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ huantian ];
    platforms = lib.platforms.linux;
  };
}
