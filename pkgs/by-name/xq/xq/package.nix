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

  cargoPatches = [
    ./0000-update-onig.patch
  ];
  cargoHash = "sha256-ACWbgGkKIn/+wPHx0dP+B0r2KDuKI4hunPwQavl6Xdo=";

  meta = {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
}
