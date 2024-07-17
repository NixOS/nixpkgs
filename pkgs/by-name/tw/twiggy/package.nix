{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "twiggy";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-NbtS7A5Zl8634Q3xyjVzNraNszjt1uIXqmctArfnqkk=";
  };

  cargoSha256 = "sha256-94pfhVZ0CNMn+lCl5O+wOyE+D6fVXbH4NAPx92nMNbM=";

  meta = with lib; {
    homepage = "https://rustwasm.github.io/twiggy/";
    description = "A code size profiler for Wasm";
    mainProgram = "twiggy";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ lucperkins ];
  };
}
