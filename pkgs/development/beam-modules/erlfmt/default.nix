{
  fetchFromGitHub,
  lib,
  rebar3Relx,
}:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.6.2";
  releaseType = "escript";

  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    hash = "sha256-tBgDCMPYXaAHODQ2KOH1kXmd4O31Os65ZinoU3Bmgdw=";
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
