{
  darwin,
  fetchFromGitHub,
  lib,
  openssl,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "unclog";
  # v0.7.3 is the latest release of Unclog, however Clippy throws an error when
  # compiling due to the `time` dependency. PR#233 (aa4ca81) resolves this.
  version = "aa4ca81bd33e6e05bd51075bcd6abbfd0e8eca56";

  src = fetchFromGitHub {
    owner = "informalsystems";
    repo = pname;
    rev = version;
    hash = "sha256-gF16ay0qbSVR038fm8fQZPFfVPajlTI8VdwM+gfMJP4=";
  };

  cargoHash = "sha256-ga1jCJiEzlsRMXijdrM25JI4DI1SQAGYKdTA3AHv52c=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = {
    description = "Unclog your changelog";
    longDescription = ''
      unclog allows you to build your changelog from a collection of independent
      files. This helps prevent annoying and unnecessary merge conflicts when
      collaborating on shared codebases.
    '';
    homepage = "https://github.com/informalsystems/unclog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ johnletey ];
  };
}
