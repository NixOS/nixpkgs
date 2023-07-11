{ lib
, rustPlatform
, fetchCrate
, cargo-c
, rust
, stdenv
}:
let
  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "libdovi";
  version = "3.1.2";

  src = fetchCrate {
    pname = "dolby_vision";
    inherit version;
    hash = "sha256-eLmGswgxtmqGc9f8l/9qvwSm+8bi06q+Ryvo7Oyr7s0=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ cargo-c ];

  buildPhase = ''
    runHook preBuild
    cargo cbuild -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${rustTargetPlatformSpec}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cargo cinstall -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${rustTargetPlatformSpec}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    cargo ctest -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${rustTargetPlatformSpec}
    runHook postCheck
  '';

  meta = with lib; {
    description = "C library for Dolby Vision metadata parsing and writing";
    homepage = "https://crates.io/crates/dolby_vision";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
