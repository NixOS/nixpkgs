{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tenki";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${version}";
    hash = "sha256-X/GnOgxwBhkrdhUmEhyxdgk5ElayMOAmtDxR2cqRJc8=";
  };

  cargoHash = "sha256-rmMUVZwNouUvFFPgZfbR4sgtig5zx1WC3bxnfPPT3yQ=";

  meta = with lib; {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
}
