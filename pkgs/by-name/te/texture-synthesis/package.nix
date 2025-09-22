{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "texture-synthesis";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "embarkstudios";
    repo = "texture-synthesis";
    rev = version;
    hash = "sha256-BJa6T+qlbn7uABKIEhFhwLrw5sG/9al4L/2sbllfPFg=";
  };

  cargoHash = "sha256-4EBMl5yvteoot6/r0tTZ95MQ6HGqgBzlRWClnlyqz/M=";

  cargoPatches = [
    # fix build with rust 1.76+
    # https://github.com/rust-lang/rust/pull/117984
    # https://github.com/rust-lang-deprecated/rustc-serialize/pull/200
    ./update-rustc-serialize.patch
  ];

  # tests fail for unknown reasons on aarch64-darwin
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  meta = with lib; {
    description = "Example-based texture synthesis written in Rust";
    homepage = "https://github.com/embarkstudios/texture-synthesis";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "texture-synthesis";
  };
}
