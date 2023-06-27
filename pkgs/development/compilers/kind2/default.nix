{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "kind2";
  version = "0.3.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-X2sjfYrSSym289jDJV3hNmcwyQCMnrabmGCUKD5wfdY=";
  };

  cargoHash = "sha256-KzoEh/kMKsHx9K3t1/uQZ7fdsZEM+v8UOft8JjEB1Zw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
  ];

  postPatch =
    let
      hvmPatch = fetchpatch {
        name = "revert-fix-remove-feature-automic-mut-ptr.patch";
        url = "https://github.com/higherorderco/hvm/commit/c0e35c79b4e31c266ad33beadc397c428e4090ee.patch";
        hash = "sha256-9xxu7NOtz3Tuzf5F0Mi4rw45Xnyh7h9hbTrzq4yfslg=";
        revert = true;
      };
    in
    ''
      pushd $cargoDepsCopy/hvm

      oldLibHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
      oldMainHash=$(sha256sum src/main.rs | cut -d " " -f 1)

      patch -p1 < ${hvmPatch}

      newLibHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
      newMainHash=$(sha256sum src/main.rs | cut -d " " -f 1)

      substituteInPlace .cargo-checksum.json \
        --replace "$oldLibHash" "$newLibHash" \
        --replace "$oldMainHash" "$newMainHash"

      popd
    '';

  # requires nightly features
  RUSTC_BOOTSTRAP = true;

  meta = with lib; {
    description = "A functional programming language and proof assistant";
    homepage = "https://github.com/higherorderco/kind";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
