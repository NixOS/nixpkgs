{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Qe+crretlKJRoNPO2+aHxCmMO9MecqGjOuvdhr4a0NU=";
  };

  cargoHash = "sha256-q8kVyj31Ne8ddMm2Q3Z/VB10SCxrq/65PH08mmtFCu4=";

  meta = {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
}
