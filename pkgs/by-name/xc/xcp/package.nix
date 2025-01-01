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

  cargoHash = "sha256-P6A1tO+XlZobvptwfJ4KH6iE/p/T1Md1sOSKZ/H/xt4=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
