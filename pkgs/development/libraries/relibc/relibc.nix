{
  meta,
  stdenv,
  buildPackages,
  rustPlatform,
  src,
  rust-cbindgen,
  expect,
}:

let
  target = stdenv.hostPlatform.rust.rustcTargetSpec;
  lockFile = "${src}/Cargo.lock";
in
rustPlatform.buildRustPackage {
  pname = "relibc";
  version = "latest";

  LD_LIBRARY_PATH = "${buildPackages.zlib}/lib";

  src = src;

  RUSTC_BOOTSTRAP = 1;

  dontInstall = true;
  dontFixup = true;
  doCheck = false;

  buildPhase = ''
    make CC=gcc AR=ar LD=ld NM=nm all
  '';

  postBuild = ''
    mkdir -p $out
    DESTDIR=$out make install
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
