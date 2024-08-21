{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tenki";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${version}";
    hash = "sha256-jd7D0iC3+s3w6uG0WqlvL9F4xQL+cQzsUvAIOc7ORgw=";
  };

  cargoHash = "sha256-3SdOUSSerTnA9VHZEmFt1LiatLwC7Dq4k/MKstE8x80=";

  meta = with lib; {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
}
