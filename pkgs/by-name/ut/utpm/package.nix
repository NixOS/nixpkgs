{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  stdenv,
  buildPackages,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "utpm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Thumuss";
    repo = "utpm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MGvPj+qF05zc2rPf1LxWVIpkZGOoDj09UfCZbQ/lBOM=";
  };

  cargoHash = "sha256-eWEriaKakEIORrQgcD5hrvSVfGRS2kU8GKNAOTIFCo0=";

  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    openssl
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
    homepage = "https://github.com/Thumuss/utpm";
    license = lib.licenses.mit;
    mainProgram = "utpm";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
})
