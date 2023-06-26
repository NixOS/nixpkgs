{ lib
, rustPlatform
, fetchCrate
, fetchpatch
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "starlark";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-h8TBWWw94Ka9C0W0i0aHACq6jO0QOLnLW+wTRzorHcc=";
  };

  cargoHash = "sha256-OLzotKyiG0JmtjH0ckRImHMPPxfQZ+8IHZtXlo1f8+Y=";

  patches = [
    # fix test broken due to using `fetchCrate`
    # https://github.com/facebookexperimental/starlark-rust/pull/78
    (fetchpatch {
      name = "fix-test-rust-loc-when-tested-from-the-crate.patch";
      url = "https://github.com/facebookexperimental/starlark-rust/commit/0e4f90c77868e506268fcb6c9d37368e5b2b8cf5.patch";
      hash = "sha256-c8irAyS2IQ5C6s+0t4+hbW8aFptkwvCu9JHLyZqZsW4=";
      stripLen = 1;
    })
  ];

  meta = with lib; {
    description = "A Rust implementation of the Starlark language";
    homepage = "https://github.com/facebookexperimental/starlark-rust";
    changelog = "https://github.com/facebookexperimental/starlark-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    broken = stdenv.isAarch64 || stdenv.isDarwin;
  };
}
