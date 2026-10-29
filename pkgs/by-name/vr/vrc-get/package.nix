{
  fetchCrate,
  installShellFiles,
  lib,
  rustPlatform,
  pkg-config,
  stdenv,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vrc-get";
  version = "1.9.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-NeNl1N6YowEi1KkZcGGXNyTfpNw6VNgSxBJDWE8t02c=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  cargoHash = "sha256-Yl7IM3zVZyqznXePPWZFrObky2vtZCULXaBK5ojKga4=";

  # Execute the resulting binary to generate shell completions, using emulation if necessary when cross-compiling.
  # If no emulator is available, then give up on generating shell completions
  postInstall =
    let
      vrc-get = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/vrc-get";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd vrc-get \
        --bash <(${vrc-get} completion bash) \
        --fish <(${vrc-get} completion fish) \
        --zsh <(${vrc-get} completion zsh)
    '';

  meta = {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "vrc-get";
  };
})
