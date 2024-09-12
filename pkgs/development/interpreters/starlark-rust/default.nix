{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "starlark-rust";
  version = "0.12.0";

  src = fetchCrate {
    pname = "starlark_bin";
    inherit version;
    hash = "sha256-3+/kEuCb0TYFQ9bS6M13OYN23DWr2DkBRWvhAn8TW5w=";
  };

  cargoHash = "sha256-60JXCBXsXei0INP0rozWqFU8dKZovJ9mn5ns87ziUac=";

  meta = with lib; {
    description = "Rust implementation of the Starlark language";
    homepage = "https://github.com/facebook/starlark-rust";
    changelog = "https://github.com/facebook/starlark-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "starlark";
  };
}
