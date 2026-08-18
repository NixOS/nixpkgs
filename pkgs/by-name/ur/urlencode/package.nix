{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "urlencode";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "urlencode";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-LvLUbtMPVbYZMUb9vWhTscYfZPtEM5GrZme3azvVlPE=";
  };

  cargoHash = "sha256-rHoqBrDFQ31jIHFZbHwjKHPDgMzM7gUCIhew03OYN6M=";

  meta = {
    description = "CLI utility for URL-encoding or -decoding strings";
    homepage = "https://github.com/dead10ck/urlencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ l0b0 ];
    mainProgram = "urlencode";
  };
})
