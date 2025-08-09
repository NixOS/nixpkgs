{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "twiggy";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FguDuah3MlC0wgz8VnXV5xepIVhTwYmQzijgX0sbdNY=";
  };

  cargoHash = "sha256-FaoEqCdMb3h93zGvc+EZ8LfYgMPY3dT/fScpRgGVeAo=";

  meta = with lib; {
    homepage = "https://rustwasm.github.io/twiggy/";
    description = "Code size profiler for Wasm";
    mainProgram = "twiggy";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ lucperkins ];
  };
}
