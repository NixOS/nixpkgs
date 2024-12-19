{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HjubzbRsmRU33oI1p1kzCFUjC2YQJhVqljd/FHzAnMw=";
  };

  cargoHash = "sha256-YBDB1g8cUOo1hS8Fi03Bvpe63bolbPmhGbvT16G73js=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
    mainProgram = "vopono";
  };
}
