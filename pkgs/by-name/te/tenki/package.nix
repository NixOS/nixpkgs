{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tenki";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${version}";
    hash = "sha256-64yNMO+Tm8APF2NnygQuub4z7kCxxf+T1urgA4Qs104=";
  };

  cargoHash = "sha256-R6Bfk3kW8721Q++dSY4u7AbUukBT0PODfFXsXuugWdk=";

  meta = with lib; {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
}
