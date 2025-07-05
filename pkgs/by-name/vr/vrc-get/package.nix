{
  fetchCrate,
  installShellFiles,
  lib,
  rustPlatform,
  pkg-config,
  stdenv,
  buildPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-gZtaeq/PDVFZPIMH/cB/ZJNP+SbksPPbz8L8Hc7FDM8=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-cG6fcSIQ0E1htEM4H914SSKDNRGM5fj52SUoLqRYzoc=";

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/vrc-get"
        else
          lib.getExe buildPackages.vrc-get;
    in
    ''
      installShellCompletion --cmd vrc-get \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "vrc-get";
  };
}
