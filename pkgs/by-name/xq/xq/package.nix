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

  cargoHash = "sha256-R2ng5l2l/5vWnTJ3kt3cURNWL4Lo55yGbSE+9hjQu20=";

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
}
