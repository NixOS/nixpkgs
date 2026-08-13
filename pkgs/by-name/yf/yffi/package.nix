{
  fetchFromGitHub,
  lib,
  rust-cbindgen,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yffi";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "y-crdt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OYqBxhpNw4LAfCLN/xBxSFuwjUV/PZvbg7Kk4AQpvvs=";
  };

  cargoHash = "sha256-eMGhHDcVeySESsgrP5Pj9BwsAgEe8rZHz+0FeFFp7IY=";

  buildAndTestSubdir = "yffi";

  nativeBuildInputs = [
    rust-cbindgen
  ];

  postBuild = ''
    cbindgen --config yffi/cbindgen.toml --crate yffi --output libyrs.h --lang C
  '';

  postCheck = ''
    $CXX -o yrs-ffi-tests -I . tests-ffi/main.cpp target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/libyrs.a
    ./yrs-ffi-tests
  '';

  postInstall = ''
    install -Dm644 libyrs.h $out/include/libyrs.h
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
