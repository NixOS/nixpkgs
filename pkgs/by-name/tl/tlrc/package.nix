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

  useFetchCargoVendor = true;
  cargoHash = "sha256-104ulV8YNdGu23/49sQQf1zroT1ceFZc+ERTECG4K6U=";

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
