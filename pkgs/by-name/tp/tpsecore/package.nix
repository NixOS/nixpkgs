{
  lib,
  fetchFromGitLab,
  rustPlatform,
  rustc,
  wasm-pack,
  wasm-bindgen-cli,
  binaryen,
}:

let
  version = "0.1.1";

  wasm-bindgen-cli-95 = wasm-bindgen-cli.override {
    version = "0.2.95";
    hash = "sha256-prMIreQeAcbJ8/g3+pMp1Wp9H5u+xLqxRxL+34hICss=";
    cargoHash = "sha256-6iMebkD7FQvixlmghGGIvpdGwFNLfnUcFke/Rg8nPK4=";
  };
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

  cargoHash = "sha256-mPaWXiDjJd/uTBpktauKWg8X9sNBb3FXw5BSGB33NxI=";

  nativeBuildInputs = [
    wasm-pack
    wasm-bindgen-cli-95
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
    maintainers = with lib.maintainers; [
      huantian
      wackbyte
    ];
    platforms = lib.platforms.linux;
  };
}
