{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tenki";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${version}";
    hash = "sha256-FlygsPvlftlCrAuViB/MpI9m10o1iVtfJ8djn5ycHa4=";
  };

  cargoHash = "sha256-mWxdZilKbC7+OygCmPB09kZJdtGbUqrGpaEZG/Bn5QQ=";

  meta = with lib; {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
}
