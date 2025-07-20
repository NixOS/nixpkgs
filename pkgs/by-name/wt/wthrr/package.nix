{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "wthrr";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ttytm";
    repo = "wthrr-the-weathercrab";
    rev = "v${version}";
    hash = "sha256-8o84FFdcEPRtbsxWCc97tTGGownxlhpIM71GiBRT6uM=";
  };

  cargoHash = "sha256-q2WkdSb6UKY1/Aut3W70vCQPsqhqv6DPuT40RaGZWAM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    # requires internet access
    "--skip=modules::localization::tests::translate_string"
    "--skip=modules::location::tests::geolocation_response"
  ];

  meta = with lib; {
    description = "Weather companion for the terminal";
    homepage = "https://github.com/ttytm/wthrr-the-weathercrab";
    changelog = "https://github.com/ttytm/wthrr-the-weathercrab/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "wthrr";
  };
}
