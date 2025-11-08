{
  lib,
  fetchFromGitLab,
  rustPlatform,
  rustc,
  wasm-pack,
  wasm-bindgen-cli_0_2_95,
  binaryen,
}:

let
  version = "0.1.1";
in
rustPlatform.buildRustPackage {
  pname = "tpsecore";
  inherit version;

  src = fetchFromGitLab {
    owner = "UniQMG";
    repo = "tpsecore";
    rev = "v${version}";
    hash = "sha256-+OynnLMBEiYwdFzxGzgkcBN6xrHoH1Q6O5i+OW7RBLo=";
  };

  cargoHash = "sha256-EM/THiR0NV4N3mFGjRYe1cpaF82rCYnOPLxv67BronU=";

  nativeBuildInputs = [
    wasm-pack
    wasm-bindgen-cli_0_2_95
    binaryen
    rustc.llvmPackages.lld
  ];

  buildPhase = ''
    runHook preBuild

    HOME=$(mktemp -d) wasm-pack build --target web --release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r pkg/ $out

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
