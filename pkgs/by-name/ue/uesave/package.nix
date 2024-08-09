{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "uesave";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "trumank";
    repo = "uesave-rs";
    rev = "v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-YRn14rF94zSTnFAIRuvw84GDRBaqmns9nvaHCTjhWQg=";
  };

  cargoHash = "sha256-sSiiMtCuSic0PQn4m1Udv2UbEwHUy0VldpGMYSDGh8g=";

  meta = with lib; {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "A library for reading and writing Unreal Engine save files (commonly referred to as GVAS).";
    homepage = "https://github.com/trumank/uesave-rs";
    license = licenses.mit;
  };
}
