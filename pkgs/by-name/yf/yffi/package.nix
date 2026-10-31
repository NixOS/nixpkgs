{
  fetchFromGitHub,
  lib,
  buildPackages,
  cargo-c,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yffi";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "y-crdt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lW6IvPyOsAOZlopLWTxqtHvuCRjGtmdYedmnyFVdQqk=";
  };

  cargoHash = "sha256-r9wT9PIsAaRp2kHvwYB0vJIAKnsVmoqkQrdmoyKtZcs=";

  buildAndTestSubdir = "yffi";

  postPatch = ''
    cat << 'EOF' >> yffi/Cargo.toml
    [features]
    capi = []

    [package.metadata.capi.header]
    name = "libyrs"
    subdirectory = false
    EOF
  '';

  nativeBuildInputs = [
    cargo-c
  ];

  buildPhase = ''
    runHook preBuild
    ${buildPackages.rust.envVars.setEnv} cargo cbuild -p yffi -j $NIX_BUILD_CORES \
      --frozen --release --prefix=${placeholder "out"} \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${buildPackages.rust.envVars.setEnv} cargo cinstall -p yffi -j $NIX_BUILD_CORES \
      --frozen --release --prefix=${placeholder "out"} \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${buildPackages.rust.envVars.setEnv} cargo ctest -p yffi -j $NIX_BUILD_CORES \
      --frozen --release --prefix=${placeholder "out"} \
      --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postCheck
  '';

  postCheck = ''
    $CXX -o yrs-ffi-tests -I . tests-ffi/main.cpp target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/libyrs.a
    ./yrs-ffi-tests
  '';

  meta = {
    description = "C foreign function interface for Yrs";
    homepage = "https://github.com/y-crdt/y-crdt/tree/main/yffi";
    downloadPage = "https://github.com/y-crdt/y-crdt/tags";
    changelog = "https://github.com/y-crdt/y-crdt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    platforms = with lib.platforms; linux;
  };
})
