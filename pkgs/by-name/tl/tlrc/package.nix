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
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-3KS/KN6/RO+PxoxbCVryymnTyWcmfXuCoc9E+asdU/E=";
  };

  cargoHash = "sha256-9MnYSmMhLn31aHwooo8W/1Rp7N5P6Tar7Ft2iXRVnh0=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
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
