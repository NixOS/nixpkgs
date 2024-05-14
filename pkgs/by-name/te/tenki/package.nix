{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tenki";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${version}";
    hash = "sha256-+04rQt+hQQan85k1AxnVaQN2xfWWrJII+GdLMSn+cck=";
  };

  cargoHash = "sha256-/ygw6bCJEeTmrG8XXMhoMl25NHK4E6mmML/V+E8e6UE=";

  meta = with lib; {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
}
