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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-th7igqDnLB+Lib2NxYNIGtUTK6IfSQo+72ohO5Ki7Ok=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+EWF21hag2kQ+YT8e+2NtdtOgyGrJL0BR2YMOxQfoDE=";

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
