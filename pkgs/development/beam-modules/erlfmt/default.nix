{
  fetchFromGitHub,
  lib,
  rebar3Relx,
}:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.7.0";
  releaseType = "escript";

  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    hash = "sha256-bljqWqpzAPP7+cVA3F+vXoUzUFzD4zXpUl/4XmMypB4=";
    tag = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/WhatsApp/erlfmt";
    description = "Automated code formatter for Erlang";
    mainProgram = "erlfmt";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
