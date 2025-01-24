{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3Y8/zRdWD6GSkhp1UabGyDrU62h1ZADYd4D1saED1ug=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-08Yw0HOaV8XKwzrODaBcHato6TfKBeVBa55MWzINAE0=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
