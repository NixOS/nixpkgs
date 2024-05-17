{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tracexec";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kxxt";
    repo = "tracexec";
    rev = "v${version}";
    hash = "sha256-X2hLaBndeYLBMnDe2MT4pgZiPj0COHG2uTvAbW+JVd4=";
  };

  cargoHash = "sha256-3xANOv+A4soDcKMINy+RnI8l6uS3koZpw3CMIUCmK5A=";

  # Remove test binaries and only retain tracexec
  postInstall = ''
    find "$out/bin" -type f \! -name tracexec -print0 | xargs -0 rm -v
  '';

  # ptrace is not allowed in sandbox
  doCheck = false;

  meta = {
    description = "A small utility for tracing execve{,at} and pre-exec behavior";
    homepage = "https://github.com/kxxt/tracexec";
    changelog = "https://github.com/kxxt/tracexec/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ fpletz ];
    mainProgram = "tracexec";
    platforms = lib.platforms.linux;
  };
}
