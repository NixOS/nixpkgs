{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tenki";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${version}";
    hash = "sha256-l2MDO0LIL+uSPiXA3+WVpan43lWJbaY9XSdQbwacRqQ=";
  };

  cargoHash = "sha256-8tabXFijgq+E6YVY1J2nAhDHFahWx7QC8S401KNy2Jc=";

  meta = with lib; {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
}
