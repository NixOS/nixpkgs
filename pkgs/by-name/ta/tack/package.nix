{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  zstd,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tack";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "tack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CUECELH3ty3Imlmbt88IC+ZkUxHPyd3FHuN9WWG4P+c=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-J0U1vSjiqMMFhSJTJlOmV/9BY8Bzc/ijG2HRcgSqm+w=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ zstd ];

  prePatch = ''
    rm .cargo/config.toml
  '';

  doInstallCheck = true;

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      tack = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/tack";
    in
    ''
      installShellCompletion --cmd tack \
        --bash    <(COMPLETE=bash ${tack}) \
        --zsh     <(COMPLETE=zsh  ${tack}) \
        --fish    <(COMPLETE=fish ${tack}) \
        --nushell <(COMPLETE=nu   ${tack})
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/manic-systems/tack";
    description = "flake-like toml nix pins, lazily fetched and transformed";
    mainProgram = "tack";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      amaanq
      atagen
      faukah
      max
      NotAShelf
    ];
  };
})
