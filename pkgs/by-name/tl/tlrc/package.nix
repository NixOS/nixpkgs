{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "tlrc";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-LXuURq+MSSkd8+VzhltX2VqKsU3PWcQLMQTqqS5oLMg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nA24qjxo1C0t4twTv2/Uu05ELiSzYLrnsRgAIFKsIxg=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    installManPage tldr.1
    installShellCompletion completions/{tldr.bash,_tldr,tldr.fish}
  '';

  meta = with lib; {
    description = "Official tldr client written in Rust";
    homepage = "https://github.com/tldr-pages/tlrc";
    changelog = "https://github.com/tldr-pages/tlrc/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "tldr";
    maintainers = with maintainers; [ acuteenvy ];
  };
}
