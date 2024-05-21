{ fetchFromGitHub, rebar3Relx, lib }:

rebar3Relx rec {
  pname = "erlfmt";
  version = "1.3.0";
  releaseType = "escript";
  src = fetchFromGitHub {
    owner = "WhatsApp";
    repo = "erlfmt";
    sha256 = "sha256-fVjEVmCnoofnfcxwBk0HI4adO0M6QOshP3uZrecZ9vM=";
    rev = "v${version}";
  };
  meta = with lib; {
    homepage = "https://github.com/WhatsApp/erlfmt";
    description = "An automated code formatter for Erlang";
    mainProgram = "erlfmt";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
