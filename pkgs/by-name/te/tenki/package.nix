{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tenki";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${version}";
    hash = "sha256-b9tByEuZ7mdPJVGgyvCnf+pyBKhO7I/B/Ak8MtM5qhU=";
  };

  cargoHash = "sha256-WvxO5muh0IGHoZr/ahE9rHs+MiXLGnQq3dgz63TwFRc=";

  meta = with lib; {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
}
