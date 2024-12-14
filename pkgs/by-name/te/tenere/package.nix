{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tenere";
  version = "0.11.2-unstable-2024-12-05";
  src = fetchFromGitHub {
    owner = "pythops";
    repo = "tenere";
    rev = "0f3181ab23066aa69aa4fec387a7e16578078179";
    hash = "sha256-HKPCX0bmXkB3LwvgE1li3dlWTgpW5CXuWZNq3mFY6FY=";
  };
  cargoHash = "sha256-u6QCs3RaLeRoVfhRzUG7wwx7kd0O3KyiC5vhZ3mE7UM=";

  requiredSystemFeatures = [ "big-parallel" ]; # for fat LTO from upstream

  meta = {
    description = "Terminal interface for large language models (LLMs)";
    homepage = "https://github.com/pythops/tenere";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ob7 ];
    mainProgram = "tenere";
  };
}
