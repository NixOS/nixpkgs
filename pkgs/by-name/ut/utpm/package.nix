{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  stdenv,
  buildPackages,
  installShellFiles,
  libgit2,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "utpm";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "typst-community";
    repo = "utpm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zCULbcQi62uMDN39wk98R1qlgBSeAHgIML39S+HeVbY=";
  };

  # Disable upstream's rustflags overrides to avoid CPU target issues
  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoHash = "sha256-Le0rVPHgtEbB3UjqUXn3NWthI2cVGH28qZSJz0o6Vlg=";

  env.OPENSSL_NO_VENDOR = 1;

  env.LIBGIT2_NO_VENDOR = 1;

  buildInputs = [
    openssl
    libgit2
  ];
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  postInstall =
    let
      utpm =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.utpm;
    in
    ''
      installShellCompletion --cmd utpm \
        --bash <(${utpm}/bin/utpm generate bash) \
        --fish <(${utpm}/bin/utpm generate fish) \
        --zsh <(${utpm}/bin/utpm generate zsh)
    '';

  meta = {
    description = "Package manager for typst";
    longDescription = ''
      UTPM is a package manager for local and remote packages. Create quickly
      new projects and templates from a singular tool, and then publish it directly
      to Typst!
    '';
    homepage = "https://github.com/typst-community/utpm";
    license = lib.licenses.mit;
    mainProgram = "utpm";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
})
