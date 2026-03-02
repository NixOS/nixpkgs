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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Thumuss";
    repo = "utpm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NlH+fPkTNqaQc2BrjerktnKS2L731K9G3z+N2xdx3kg=";
  };

  cargoHash = "sha256-WR9LD5HjLgh9jirnjTc6BeNg8KjVZI+DuJRYEbN3tmE=";

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
