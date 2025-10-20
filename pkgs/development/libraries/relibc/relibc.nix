{
  meta,
  stdenv,
  buildPackages,
  rustPlatform,
  src,
  rust-cbindgen,
  # rust,
  # cargo,
  expect,
}:

let
  d = i: builtins.trace "${i}" i;
  target = stdenv.hostPlatform.rust.rustcTargetSpec;
  lockFile = "${src}/Cargo.lock";
  # rustPlatform = makeRustPlatform {
  #   rustc = rust;
  #   cargo = rust;
  # };
  # rustPlatform = buildPackages.makeRustPlatform {
  #   rustc = d rust;
  #   cargo = rust;
  # };
in
rustPlatform.buildRustPackage {
  pname = "relibc";
  version = "0.2.5";

  # LD_LIBRARY_PATH = "${buildPackages.zlib}/lib";
  # RUST_SRC_PATH = d "${rustPlatform.rustLibSrc}";
  # preCheck = ''
  #   export RUST_SRC_PATH=${rustPlatform.rustLibSrc}
  # '';

  src = src;

  # RUSTC_BOOTSTRAP = 1;

  # dontInstall = true;
  # dontFixup = true;
  doCheck = false;
  patchPhase = ''
    patchShebangs --build renamesyms.sh stripcore.sh
  '';

  buildPhase = ''
    make CC=gcc AR=ar LD=ld NM=nm CARGO_COMMON_FLAGS="" all
  '';

  postBuild = ''
    mkdir -p $out
    DESTDIR=$out make CC=gcc AR=ar LD=ld NM=nm install
  '';

  nativeBuildInputs = [
    rust-cbindgen
    expect
  ];

  TARGET = target;

  cargoLock = {
    lockFile = lockFile;
    allowBuiltinFetchGit = true;
  };

  # error: Usage of `RUSTC_WORKSPACE_WRAPPER` requires `-Z unstable-options`
  auditable = false;

  inherit meta;
}
