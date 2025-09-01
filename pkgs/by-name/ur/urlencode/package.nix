{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "urlencode";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "urlencode";
    rev = "v${version}";
    sha256 = "sha256-LvLUbtMPVbYZMUb9vWhTscYfZPtEM5GrZme3azvVlPE=";
  };

  cargoHash = "sha256-rHoqBrDFQ31jIHFZbHwjKHPDgMzM7gUCIhew03OYN6M=";

  meta = with lib; {
    description = "CLI utility for URL-encoding or -decoding strings";
    homepage = "https://github.com/dead10ck/urlencode";
    license = licenses.mit;
    maintainers = with maintainers; [ l0b0 ];
    mainProgram = "urlencode";
  };
}
