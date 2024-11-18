{
  lib,
  rustPlatform,
  libiconv,
  stdenv,
  installShellFiles,
  darwin,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "volta";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "volta-cli";
    repo = "volta";
    rev = "v${version}";
    hash = "sha256-+j3WRpunV+3YfZnyuKA/CsiKr+gOaP2NbmnyoGMN+Mg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uBN5pRmd7l58Q4eauGQhUbab4kKHYm3VpJW+aRDsHJ4=";

  buildInputs =
    [ installShellFiles ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      libiconv
    ];

  HOME = "$TMPDIR";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd volta \
      --bash <($out/bin/volta completions bash) \
      --fish <($out/bin/volta completions fish) \
      --zsh <($out/bin/volta completions zsh)
  '';
  meta = with lib; {
    description = "Hassle-Free JavaScript Tool Manager";
    longDescription = ''
      With Volta, you can select a Node engine once and then stop worrying
      about it. You can switch between projects and stop having to manually
      switch between Nodes. You can install npm package binaries in your
      toolchain without having to periodically reinstall them or figure out why
      they’ve stopped working.

      Note: Volta cannot be used on NixOS out of the box because it downloads
      Node binaries that assume shared libraries are in FHS standard locations.
    '';
    homepage = "https://volta.sh/";
    changelog = "https://github.com/volta-cli/volta/blob/main/RELEASES.md";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fbrs ];
  };
}
