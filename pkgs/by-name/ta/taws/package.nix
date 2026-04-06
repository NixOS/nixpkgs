{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  makeWrapper,
  ssm-session-manager-plugin  ? null,
  stdenv,
  testers,
  nix-update-script,
  taws
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taws";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "huseyinbabal";
    repo = "taws";
    rev = "cce20b064f758feb263fc266a83473f5b96ed741";
    hash = "sha256-76dC5ZLhQkItqGdWkq+U8mzimjDAAkzzpopx8ZPHCx4=";
  };

  cargoHash = "sha256-62Pk1RRx0eErGWNCYEyw0jFoNp97a+1kn5brgd81P5k=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optional (ssm-session-manager-plugin != null) makeWrapper;

  buildInputs = [ openssl ];

  postInstall = lib.optionalString (ssm-session-manager-plugin != null) ''
    wrapProgram $out/bin/taws \
      --prefix PATH : ${lib.makeBinPath [ ssm-session-manager-plugin ]}
  '';


  

  # adapting the test from k9s since it's a similar tool
  passthru = {
    tests.version = testers.testVersion {
      package = taws;
      command = "HOME=$(mktemp -d) taws --version";
      inherit (finalAttrs) version;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal UI for AWS — navigate, observe, and manage AWS resources";
    homepage = "https://github.com/huseyinbabal/taws";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ skewballfox ];
    mainProgram = "taws";
  };
})
