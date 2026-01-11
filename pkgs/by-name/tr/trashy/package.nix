{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "trashy";
  version = "2.0.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1xHyhAV8hpgMngQdamRzEliyG60t+I3KfsDJi0+180o=";
  };

  cargoHash = "sha256-tlz8WeFOxNPJxCqwqH98S/JkU7MZSDj/OaPvNkf6iwg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd trash \
      --bash <($out/bin/trash completions bash) \
      --fish <($out/bin/trash completions fish) \
      --zsh <($out/bin/trash completions zsh) \

    installManPage --name trashy.1 <($out/bin/trash manpage)
  '';

  meta = {
    description = "Simple, fast, and featureful alternative to rm and trash-cli";
    homepage = "https://github.com/oberblastmeister/trashy";
    changelog = "https://github.com/oberblastmeister/trashy/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ oberblastmeister ];
    mainProgram = "trash";
    # darwin is unsupported due to https://github.com/Byron/trash-rs/issues/8
    platforms = lib.platforms.linux;
  };
}
