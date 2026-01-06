{
  fetchFromGitHub,
  lib,
  rust-cbindgen,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yffi";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "y-crdt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RFdLEsKQxt8BGqbf5FFM7mZD64glW7bTKRJaAQOe+vo=";
  };

  cargoHash = "sha256-RL9lBc7lSmc6jOavE5lZupmaNGZgQhJBedNhjfHVajg=";

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
