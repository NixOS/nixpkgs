{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "trippy";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "fujiapple852";
    repo = "trippy";
    rev = version;
    hash = "sha256-LRO2blzzSaYjQVmXpN2aF3qPhfzCrbyc9R7C11UVyV8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-+PaSLq++tKA6dy4CI1EYrEDdXi2TI9XHjvMLfwDp/HA=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    local INSTALL="$out/bin/trip"
    installShellCompletion --cmd trip \
      --bash <($out/bin/trip --generate bash) \
      --fish <($out/bin/trip --generate fish) \
      --zsh <($out/bin/trip --generate zsh)
  '';

  meta = with lib; {
    description = "Network diagnostic tool";
    homepage = "https://trippy.cli.rs";
    changelog = "https://github.com/fujiapple852/trippy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "trip";
  };
}
