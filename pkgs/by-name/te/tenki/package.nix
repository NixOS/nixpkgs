{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tenki";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${version}";
    hash = "sha256-FItq/rnxJsEnKFPUR59Wo3eQvaykaIyCohCcOlPrdAE=";
  };

  cargoHash = "sha256-PhilKt7gLWoOOpkpSPa1/E33rmHvX466hSCGoNfezq0=";

  meta = with lib; {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
}
