{
  fetchFromGitHub,
  lib,
  rebar3Relx,
}:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.8.0";
  releaseType = "escript";

  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    hash = "sha256-0guZxRStVHnUCh9+tmP+/FzgZF+TUgB2oCZu+P4FJBs=";
    tag = "v${version}";
  };

  meta = {
    homepage = "https://github.com/WhatsApp/erlfmt";
    description = "Automated code formatter for Erlang";
    mainProgram = "erlfmt";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
