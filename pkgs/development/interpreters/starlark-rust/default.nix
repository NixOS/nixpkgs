{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "starlark-rust";
  version = "0.10.0";

  src = fetchCrate {
    pname = "starlark_bin";
    inherit version;
    hash = "sha256-7AoNRTLyTYsUass9bMJMBUN+GrfUzEGM9cED5VsRESs=";
  };

  cargoHash = "sha256-Q00JJRiubrxnI0nFQqUTbxTTB70XV93HJycjdlvV+74=";

  meta = with lib; {
    description = "A Rust implementation of the Starlark language";
    homepage = "https://github.com/facebookexperimental/starlark-rust";
    changelog = "https://github.com/facebookexperimental/starlark-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "starlark";
  };
}
