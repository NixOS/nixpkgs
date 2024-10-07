{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0JInvnQRINItUyAqnDBT0uRlF7zKRA4S/IyqxqmHnvQ=";
  };

  cargoHash = "sha256-44JBZu08PDkyeBMscchNp6N9aF99b5lZWDhp4K42xsY=";

  meta = with lib; {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      mgttlinger
    ];
  };
}
