{
  fetchFromGitHub,
  lib,
  rebar3Relx,
  erlang,
}:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.9.0";
  releaseType = "escript";

  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    hash = "sha256-uiZawnGyHqqp0RKPh6et84+0jehII0ou0xcw2PDNh8g=";
    tag = "v${version}";
  };

  buildInputs = [ erlang ];

  meta = {
    homepage = "https://github.com/WhatsApp/erlfmt";
    description = "Automated code formatter for Erlang";
    mainProgram = "erlfmt";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
