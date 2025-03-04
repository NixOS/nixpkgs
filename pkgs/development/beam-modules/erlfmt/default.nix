{
  fetchFromGitHub,
  rebar3Relx,
  lib,
}:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.6.0";
  releaseType = "escript";
  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    sha256 = "sha256-p4cdnKDY02XqdFOkijhOo527eZenfMF8J2dbuvH/hcY=";
    rev = "v${version}";
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
