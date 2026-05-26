{
  lib,
  stdenv,
  callPackage,
  swift,
  swiftpm,
  swiftpm2nix,
  installShellFiles,
  Dispatch,
  Foundation,
}:
let
  sources = callPackage ../sources.nix { };
  generated = swiftpm2nix.helpers ./generated;
in
stdenv.mkDerivation {
  pname = "swift-format";

  inherit (sources) version;
  src = sources.swift-format;

  nativeBuildInputs = [
    swift
    swiftpm
    installShellFiles
  ];
  buildInputs = [ Foundation ];

  env.LD_LIBRARY_PATH = lib.optionalString stdenv.hostPlatform.isLinux (
    lib.makeLibraryPath [ Dispatch ]
  );

  configurePhase = generated.configure;

  # We only install the swift-format binary, so don't need the other products.
  swiftpmFlags = [ "--product swift-format" ];

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp $binPath/swift-format $out/bin/

    # Generate shell completions
    for shell in bash zsh fish; do
      $out/bin/swift-format --generate-completion-script $shell > swift-format.$shell
    done

    installShellCompletion --cmd swift-format \
      --bash swift-format.bash \
      --zsh swift-format.zsh \
      --fish swift-format.fish
  '';

  meta = {
    description = "Formatting technology for Swift source code";
    homepage = "https://github.com/apple/swift-format";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
    mainProgram = "swift-format";
  };
}
