{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yfQSGmLWXyOI5slB8AMcVTfQQKUXY3mBaeDPya4KtKo=";
  };

  cargoHash = "sha256-WuYAE2msctMf+7C1h5pNGyjrEInnT6PxfZ94bZhzB5w=";

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
