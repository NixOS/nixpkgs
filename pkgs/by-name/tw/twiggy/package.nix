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
    hash = "sha256-NbtS7A5Zl8634Q3xyjVzNraNszjt1uIXqmctArfnqkk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-thGehtb8cF4b/G76nbkuBqQyNodaCbAiDBsrUKQ3zbQ=";

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
