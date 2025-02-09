{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W9gSVZcL171ibcBBblQo1+baux78q+ZuGAOC7nAyQ20=";
  };

  # no such file or directory errors
  doCheck = false;

  useFetchCargoVendor = true;
  cargoHash = "sha256-X3zXCiMZAolPLjCKSKocc00t3/P2tS57a2+BWW3VaD0=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
