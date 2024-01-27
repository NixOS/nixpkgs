{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "starlark-rust";
  version = "0.11.0";

  src = fetchCrate {
    pname = "starlark_bin";
    inherit version;
    hash = "sha256-/dy9uzXLZipKzFaslOmlzeEsOD89pprwFTopYpsmHGM=";
  };

  cargoHash = "sha256-Ict1Lh+JPZ5dmC+ul0phcQug9nYeaILLCtaHQOI6qBk=";

  meta = with lib; {
    description = "A Rust implementation of the Starlark language";
    homepage = "https://github.com/facebookexperimental/starlark-rust";
    changelog = "https://github.com/facebookexperimental/starlark-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "starlark";
  };
}
